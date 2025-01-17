# Looks for Structs and adds them to the database
module Tabitha
  class Query
    class Struct < Tabitha::Engine::Query
      def code
        <<~QUERY.strip
        [ ; This variant captures structs like:
          ;
          ; @vis struct @type @body?
          ;
          ; These are not captured by this query
          ;
          ; struct NewType(isize);
          ; type TypeAlias = isize;
          (struct_item
            (visibility_modifier)? @vis
            name: (type_identifier) @type
            type_parameters: (type_parameters)? @generics
            body: (field_declaration_list)? @body
          )
        ]
        QUERY
      end

      def run!(src = nil)
        fields = {}

        super.map do |match|
          name = match["type"]

          # If we're not given a snippet to act on, then the Location must have been provided via `src`.

          location = Tabitha::Engine::Location.new(
            file: src,
            line: name.range.start_point.row,
            column: name.range.start_point.column
          )
          type_name = name.text
          generics = match["generics"].text if match.has_key?("generics")

          body = match["body"]

          Model::Struct.create!(name: type_name, generics: generics, location: location, body: body)
        end
      end
    end
  end
end
