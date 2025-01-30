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
                                    left: (type_identifier) @generic.type
                                    bounds: (trait_bounds (_) @generic.bound))])?
            (where_clause
              (where_predicate
                left: [(type_identifier) (generic_type)] @generic.type
                bounds: (trait_bounds (_) @generic.bound)))?
            body: (field_declaration_list
                    (field_declaration
                      (visibility_modifier)? @field.visibility
                      name: (field_identifier) @field.name
                      type: (_) @field.type))?
          )
        QUERY
      end

      def run!(src = nil)
        super.group_by do |result|
          result['struct.name'].text.to_sym
        end.map do |name, matches|
            struct_node = matches[0]['struct.name']
            name = struct_node.text.to_sym

            location = Engine::Location::from(
              src: src,
              node: struct_node
            )


            # TODO: Build the struct instead of the hash
            # TODO: Pretty sure this can be built outside the loop, harmless here though I think.
            struct_vis = matches[0]['struct.visibility'].text.to_sym if matches[0].has_key?('struct.visibility')
            struct = Model::Struct[name] || Model::Struct.create!(visibility: struct_vis, name: name, location: location)

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

                generic = components[:generic][type] || Model::Generic::new(name: type, location: location)

                if match.has_key?('generic.bound')
                  node = match['generic.bound']
                  generic.bounds << Model::Bound.from(
                    node: node,
                    # TODO: can I recover src from node? If so, can drop this org.
                    src: src,
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
                  location: Engine::Location::from(src: src, node: name_node),
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
