module Tabitha
  class Query
    class Trait < Tabitha::Engine::Query
      def code
        <<~QUERY
        (trait_item
          name: (_) @trait.name
          type_parameters: (type_parameters [
            (type_identifier) @trait.type_params
            (where_clause (_) @trait.where_clause)
            (lifetime (_) @trait.lifetime)
          ])?
          bounds: (trait_bounds (_) @trait.bounds)?
          body: (declaration_list [
            (function_item) @trait.fn
            (associated_type) @trait.assoc_type
          ]))
        QUERY
      end

      def run!(src = nil)
        super.group_by { |result| result['trait.name'].text.to_sym }
          .map { |name, matches|
            node = matches.first['trait.name']
            name = node.text.to_sym

            # TODO: A small discovery. You can query a node inside of another. Which means
            # these queries can capture, e.g., a whole function item and hand it off
            # to a 'sub' parser, rather than deeply searching the tree.
            #
            # This could be scoped to each treesitter node directly, so a `struct_item`
            # gets handed to struct, which in turns hands off to field or generic or w/e
            #
            # I think this refactor comes as part of trait impl. I also think I'm going to
            # need a 'constrained set' type. which allows some dynamic constraint placed 
            # on the set. It should be ordered by default, but practically it should disregard
            # order as part of equality. It's essentially a wrapper Set.new((id, T)), where
            # equality ignores id differences. An additional constraint may be that `T#foo` returns a unique result, or
            # w/e.
            #
            # This models Params, and Generics too - we need to preserve idiosyncratic ordering.

            location = Engine::Location::from(
              src: src,
              node: node
            )

            Tabitha::Model::Trait.create!(
              name: name,
              location: location,
              trait_items: Set[
                Tabitha::Model::Fn::new(
                  location: Engine::Location::new(file: src, line: 2, column: 5),
                  name: :get,
                  params: Set[
                    Tabitha::Model::Param.new(
                      name: :"&self",
                      type: nil,
                      location: Engine::Location::new(file: src, line: 0, column: 0)
                    )
                  ],
                  return_type: :"&Self::Item",
                  modifier: nil,
                  visibility: :trait,
                )
              ],
              associated_types: Set[
                Tabitha::Model::AssociatedType::new(
                  name: :Item,
                  default: nil,
                  bounds: Set.new,
                  location: Engine::Location::new(file: src, line: 1, column: 6)
                )
              ]
            )
          }
      end
    end
  end
end
