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
            body: (field_declaration_list)? @body
          )
        ]
        QUERY
      end

      def run!
        results = if @target_code.nil?
          @target_code.query(self.code)
        else
          super
        end

        fields = {}

        results.map do |match|
          name = match["type"]

          # If we're not given a snippet to act on, then the Location must have been provided via `src`.
          file = self.src if @target_code.nil?

          location = Tabitha::Engine::Location.new(
            file: file,
            line: name.range.start_point.row,
            column: name.range.start_point.column
          )
          type_name = name.text

          body = match["body"]

          Model::Struct.create!(type_name, location, body)
        end
      end
    end
  end
end
