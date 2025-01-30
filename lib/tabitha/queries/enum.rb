# Looks for Enums and adds them to the database
module Tabitha
  class Query
    class Enum < Tabitha::Engine::Query
      def code
        <<~QUERY.strip
        (enum_item
          (visibility_modifier)? @enum.vis
          name: (type_identifier) @enum.name
          type_parameters: (type_parameters
            (constrained_type_parameter
              left: (_) @enum.type_params.type
              bounds: (trait_bounds (_) @enum.type_params.bounds))
            )?
          (where_clause
            (where_predicate
              left: (_) @enum.type_params.type
              bounds: (trait_bounds (_) @enum.type_params.bounds)))?
          body: (enum_variant_list
            (enum_variant
              name: (identifier) @enum.variant.name
              body: [
                (field_declaration_list
                  (field_declaration
                    name: (field_identifier) @enum.variant.field_name
                    type: (_) @enum.variant.field_type
                    )
                  )
                (ordered_field_declaration_list
                  type: (_) @enum.variant.field_type)
              ]?)?
            )
          )
        QUERY
      end

      def run!(src = nil)
        super.group_by do |result|
          result['enum.name'].text.to_sym
        end.map do |name, matches|
          node = matches.first['enum.name']
          location = Tabitha::Engine::Location.from(src: src, node: node)
          visibility = if matches.any? { |v| not v['enum.vis'].nil? }
            # FIXME: There should only ever be one of these, but I suppose I should assert that
            matches.map { |v| v['enum.vis'] }.compact.map { |v| v.text.to_sym }.first
          end

          variants = matches.map { |v| v['enum.variant.name'] }.compact.map { |v| [v, v.text.to_sym] }.map do |variant_node, variant_name|
            variant = Tabitha::Model::Enum::Variant.new(name: variant_name, location: Engine::Location::from(src: src, node: variant_node), fields: {})

            matches.select { |v| v['enum.variant.name'].text.to_sym == variant_name and v.has_key?('enum.variant.field.name') }.map do |field|
              binding.pry
            end

            variant
          end
          variants = Set[*variants]

          enum = Model::Enum.create!(
            name: name,
            visibility: visibility,
            location: location,
            variants: variants,
              # FIXME: Just generic names, no bounds, but shoved into a hash
            generics: matches.map { |v| v['enum.type_params.type'] }.compact.map { |v| v.text.to_sym }.map.with_object({}) { |v, h| h[v] = nil }
          )
        end
      end
    end
  end
end
