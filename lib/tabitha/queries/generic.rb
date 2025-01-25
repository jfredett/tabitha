module Tabitha
  class Query
    class Generic < Engine::Query
      def code
        <<~QUERY.strip
          (type_parameters [
             (type_identifier) @type

             (constrained_type_parameter
               left: (type_identifier) @type
               bounds: (trait_bounds (type_identifier) @bounds))
          ])
        QUERY
      end

      def run!(src = nil)
        fields = {}

        super.map do |match|
          name = match["type"]

          location = Engine::Location.new(
            file: src,
            line: name.range.start_point.row,
            column: name.range.start_point.column
          )
          generic_name = name.text

          @bounds = []
          if match.has_key?("bounds")
            bounds = match["bounds"]
            @bounds << Model::Constraint::new(
              name: generic_name,
              trait: bounds.text.to_sym,
              location: Engine::Location.new(file: src, line: bounds.range.start_point.row, column: bounds.range.start_point.column),
              generics: []
            )
          end


          Model::Generic.new(name: generic_name, location: location)
        end
      end
    end
  end
end
