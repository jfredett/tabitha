module Tabitha
  class Query
    class WhereClause < Tabitha::Engine::Query
      def code
        <<~QUERY.strip
        (where_clause
          (where_predicate
            left: (type_identifier) @type
            bounds: (trait_bounds (type_identifier) @bounds)))
        QUERY
      end

      def run!(src = nil)
        fields = {}

        super.map do |match|
          type = match["type"]

          location = Tabitha::Engine::Location.new(
            file: src,
            line: type.range.start_point.row,
            column: type.range.start_point.column
          )
          type_name = type.text

          bounds = match["bounds"]
          binding.pry


          # TODO: `generics` here means `generics` _drawn from the parent, and _applied within the constraint. i.e.,
          # `struct Foo<T, U> where T : Bar<U>;` would have `T` and `U` as generics, and `U` as a generic within the
          # constraint.
          Model::Constraint::new(name: type_name, trait: bounds.text, generics: [], location: location)
        end
      end
    end
  end
end
