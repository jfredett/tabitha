# Captures items in `impl (Trait<T> for)? #TYPE` blocks.
# TODO: I think I'm missing all the Async stuff?
class Query
  class Impl < SCM
    def code(type_name)
      <<~QUERY.strip
      [
        ; impl @trait.name<@trait.args> for @type.name {
        ;   @function.vis? @function.mod? fn @function.name(@function.parameters) -> @function.return;
        ;   ...
        ; }
        (impl_item
          trait: (generic_type
            type: (type_identifier) @trait.name
            type_arguments: (type_arguments) @trait.args)
          type: (type_identifier) @type.name
          body: (declaration_list
            (function_item
              (visibility_modifier)? @function.vis
              (function_modifiers)? @function.mod
              name: (identifier) @function.name
              (parameters) @function.parameters
              return_type: (type_identifier) @function.return
            )
          )
        )

        ; impl @trait.name for @type.name {
        ;   @function.vis? @function.mod? fn @function.name(@function.parameters) -> @function.return;
        ;   ...
        ; }
        (impl_item
          trait: (type_identifier)? @trait.name
          type: (type_identifier) @type.name
          body: (declaration_list
            (function_item
              (visibility_modifier)? @function.vis
              (function_modifiers)? @function.mod
              name: (identifier) @function.name
              parameters: (parameters) @function.parameters
              return_type: (type_identifier) @function.return)))

        ; impl @type.name {
        ;   @function.vis? @function.mod? fn @function.name(@function.parameters) -> @function.return;
        ;   ...
        ; }
        (impl_item
          type: (type_identifier) @type.name
          body: (declaration_list
            (function_item
              (visibility_modifier)? @function.vis
              (function_modifiers)? @function.mod
              name: (identifier) @function.name
              (parameters) @function.parameters
              return_type: (type_identifier) @function.return)))
      ] (#eq? @type.name #{type_name})
      QUERY
    end

    def run!(type_name)
      SourceTree.query(self.code(type_name))
    end
  end
end
