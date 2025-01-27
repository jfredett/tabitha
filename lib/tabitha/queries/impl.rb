# Captures items in `impl (Trait<T> for)? #TYPE` blocks.
# TODO: I think I'm missing all the Async stuff?
module Tabitha
  class Query
    class Impl < Tabitha::Engine::Query
      def code
        <<~QUERY
        (impl_item
            type_parameters: (type_parameters
                    (constrained_type_parameter
                      left: (_) @impl.type_params.type
                      bounds: (trait_bounds (_) @impl.type_params.bounds))
                )?
            trait: (_)? @impl.trait
            type: [
               (type_identifier) @impl.type
               (generic_type
                 type: (_) @impl.type
                 type_arguments: (type_arguments (_) @impl.type_params.type))
            ]
            (where_clause
               (where_predicate
                 left: (_) @impl.type_params.type
                 bounds: (trait_bounds (_) @impl.type_params.bounds)))?
            body: (declaration_list [
              (const_item
                name: (identifier) @impl.const.name
                type: (type_identifier) @impl.const.type
                value: (_) @impl.const.value)

              (function_item
                (visibility_modifier)? @impl.fn.vis
                (function_modifiers)? @impl.fn.mods
                name: (identifier) @impl.fn.name
                (parameters) @impl.fn.params
                return_type: (type_identifier) @impl.fn.return_type)
              ]))
        QUERY
      end
      # def code(type_name)
      #   <<~QUERY.strip
      #   [
      #     ; impl @trait.name<@trait.args> for @type.name {
      #     ;   @function.vis? @function.mod? fn @function.name(@function.parameters) -> @function.return;
      #     ;   ...
      #     ; }
      #     (impl_item
      #       trait: (generic_type
      #         type: (type_identifier) @trait.name
      #         type_arguments: (type_arguments) @trait.args)
      #       type: (type_identifier) @type.name
      #       body: (declaration_list
      #         (function_item
      #           (visibility_modifier)? @function.vis
      #           (function_modifiers)? @function.mod
      #           name: (identifier) @function.name
      #           (parameters) @function.parameters
      #           return_type: (type_identifier) @function.return
      #         )
      #       )
      #     )

      #     ; impl @trait.name for @type.name {
      #     ;   @function.vis? @function.mod? fn @function.name(@function.parameters) -> @function.return;
      #     ;   ...
      #     ; }
      #     (impl_item
      #       trait: (type_identifier)? @trait.name
      #       type: (type_identifier) @type.name
      #       body: (declaration_list
      #         (function_item
      #           (visibility_modifier)? @function.vis
      #           (function_modifiers)? @function.mod
      #           name: (identifier) @function.name
      #           parameters: (parameters) @function.parameters
      #           return_type: (type_identifier) @function.return)))

      #     ; impl @type.name {
      #     ;   @function.vis? @function.mod? fn @function.name(@function.parameters) -> @function.return;
      #     ;   ...
      #     ; }
      #     (impl_item
      #       type: (type_identifier) @type.name
      #       body: (declaration_list
      #         (function_item
      #           (visibility_modifier)? @function.vis
      #           (function_modifiers)? @function.mod
      #           name: (identifier) @function.name
      #           (parameters) @function.parameters
      #           return_type: (type_identifier) @function.return)))
      #   ] (#eq? @type.name #{type_name})
      #   QUERY
      # end

      def run!(src = nil)
        results = super(src)
      end
    end
  end
end
