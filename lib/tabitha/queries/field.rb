module Tabitha
  class Query
    class Field < Tabitha::Engine::Query
      def code
        <<~QUERY.strip
        [
          (field_declaration_list
            (field_declaration
              (visibility_modifier)? @field.vis
              name: (field_identifier) @field.name
              type: (_) @field.type))
        ]
        QUERY
      end

      def run!(src = nil)
        fields = {}

        super.map do |match|
          name = match["field.name"]

          location = Tabitha::Engine::Location.new(
            file: src,
            line: name.range.start_point.row,
            column: name.range.start_point.column
          )
          field_name = name.text
          vis = match["field.vis"].text if match.has_key?("field.vis")
          type = match["field.type"].text

          Model::Field.new(name: field_name, location: location, vis: vis, type: type)
        end
      end
    end
  end
end

