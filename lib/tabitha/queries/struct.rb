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
                               [ (type_identifier) @generic.type
                                 (constrained_type_parameter
                  ; TODO: Extend this to capture generics inside of the constraints. At least 1 layer deep.
                                    left: (type_identifier) @generic.type
                                    bounds: (trait_bounds (_) @generic.bound))])?
            (where_clause
              (where_predicate
                (type_identifier) @generic.type
                (trait_bounds (type_identifier) @generic.bound))
              )?
            body: (field_declaration_list
                    (field_declaration
                      (visibility_modifier)? @field.visibility
                      name: (field_identifier) @field.name
                      type: (_) @field.type))?
            )
        QUERY
      end

      def run!(src = nil)
        structs = []
        results = super


        struct_name = results[0]['struct.name']
        name = struct_name.text.to_sym

        results.group_by do |result|
          result['struct.name'].text.to_sym
        end.map do |name, matches|
            # TODO: write something that wraps the `match` object and does some of the checking for us. Also can capture
            # file location transparently that way.
            location = Engine::Location::new(
              file: src,
              # This is wrong, but I'm not threading source tracking through for this just yet.
              line: matches[0]['struct.name'].range.start_point.row,
              column: matches[0]['struct.name'].range.start_point.column,
            )

            # TODO: Build the struct instead of the hash
            struct = Model::Struct[name] || Model::Struct.create!(name: name, location: location)

            components = Hash.new { |h, k| h[k] = {} }
            matches.map do |match|
              # `matches` current form [[generic.type, generic.bound, field.vis?, field.name, field.type], [repeat]...]
              # desired form {
              #   generic: [{type: type, bound: bound}, ...],
              #   fields: [{vis: vis, name: name, type: type}, ...]}
              # }

              # TODO: Push this into Generic?
              if match.has_key?('generic.type')
                type = match.delete('generic.type').text.to_sym

                generic = components[:generic][type] || Model::Generic::new(name: type, location: location, parent: struct)

                # TODO: Push this into Constraint?
                if match.has_key?('generic.bound')
                  bound = match.delete('generic.bound')
                  generic.constraints[bound.text.to_sym] ||= Model::Constraint.new(
                    name: type,
                    trait: bound.text.to_sym,
                    generics: [], # FIXME: this is wrong.
                    location: Engine::Location::new(
                      file: src,
                      line: bound.range.start_point.row,
                      column: bound.range.start_point.column
                    ),
                    # OQ: Not sure this is right, might should be struct
                    parent: generic
                  )
                end
                components[:generic][type] = generic
              end

              # TODO: Push this into Field?
              if match.has_key?('field.name')
                name_node = match.delete('field.name')
                name = name_node.text.to_sym
                type = match.delete('field.type').text.to_sym
                vis = match.delete('field.visibility').text if match.has_key?('field.visibility')

                components[:field][name] ||= Model::Field.new(
                  name: name,
                  type: type,
                  visibility: vis,
                  location: Engine::Location::new(
                    file: src,
                    line: name_node.range.start_point.row,
                    column: name_node.range.start_point.column
                  ),
                  parent: struct
                )
              end
            end

            struct.generics = components[:generic]
            struct.fields = components[:field]

            struct
          end
      end
    end
  end
end
