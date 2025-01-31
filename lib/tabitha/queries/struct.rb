# Looks for Structs and adds them to the database
module Tabitha
  class Query
    class Struct < Tabitha::Engine::Query
      def code
        <<~QUERY.strip
          (struct_item
            (visibility_modifier)? @struct.visibility
            name: (type_identifier) @struct.name
            type_parameters: (type_parameters
              [ (type_identifier) @struct.type_params.type
                (constrained_type_parameter
                  left: (type_identifier) @struct.type_params.type
                  bounds: (trait_bounds (_) @struct.type_params.bound))])?
            (where_clause
              (where_predicate
                left: [(type_identifier) (generic_type)] @struct.type_params.type
                bounds: (trait_bounds (_) @struct.type_params.bound)))?
            body: (field_declaration_list
              (field_declaration
                (visibility_modifier)? @struct.field.visibility
                name: (field_identifier) @struct.field.name
                type: (_) @struct.field.type))?
          )
        QUERY
      end

      def run!(src = nil)
        super.group_by do |result|
          result['struct.name'].text.to_sym
        end.map do |name, matches|
            node = matches.first['struct.name']
            name = node.text.to_sym

            location = Engine::Location::from(
              src: src,
              node: node
            )

            # TODO: This is _very_ similar to the enum query (by design), and I suspect we can push some of this parsing
            # into the relevant model classes themselves?
            # TODO: Pretty sure this can be built outside the loop, harmless here though I think.
            visibility = if matches.any? { |v| not v['struct.visibility'].nil? }
              matches.map { |v| v['struct.visibility'] }.compact.map { |v| v.text.to_sym }.first
            end

            generics = matches.map { |v| v['struct.type_params.type'] }.compact.map { |g| [g, g.text.to_sym] }
            generics = generics.map do |generic_node, generic_name|
              generic = Tabitha::Model::Generic.new(name: generic_name, location: Engine::Location.from(src: src, node: generic_node))

              matches.select do |v|
                v['struct.type_params.type'].text.to_sym == generic_name && v.has_key?('struct.type_params.bound')
              end.each do |bound|
                generic << Tabitha::Model::Bound.from(src: src, node: bound['struct.type_params.bound'])
              end

              generic
            end
            generics = Set[*generics]

            fields = matches.map { |v| v['struct.field.name'] }.compact.map { |f| [f, f.text.to_sym] }
            fields = fields.map do |field_node, field_name|
              field_vis = matches.select { |v| v['struct.field.name'].text.to_sym == field_name }.map { |v| v['struct.field.visibility'] }.compact.map { |v| v.text.to_sym }.first
              type = matches.select { |v| v['struct.field.name'].text.to_sym == field_name }.map { |v| v['struct.field.type'] }.compact.map { |v| v.text.to_sym }.first
              field = Tabitha::Model::Field.new(
                name: field_name,
                type: type,
                visibility: field_vis,
                location: Engine::Location.from(src: src, node: field_node),
              )

              field
            end
            fields = Set[*fields]

            Model::Struct.create!(
              visibility: visibility,
              name: name,
              location: location,
              generics: generics,
              fields: fields
            )
          end
      end
    end
  end
end
