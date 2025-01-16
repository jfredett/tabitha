# Looks for Structs and adds them to the database
class Query
  class Struct < SCM
    def code
      <<~QUERY.strip
      [ ; This variant captures structs like:
        ;
        ; @vis struct @type {
        ;  <@field.vis @field.name: @field.type>,*
        ; }
        ;
        ; These are not captured by this query
        ;
        ; struct NewType(isize);
        ; type TypeAlias = isize;
        (struct_item
          (visibility_modifier)? @vis
          name: (type_identifier) @type
          body:
            (field_declaration_list
              (field_declaration
                (visibility_modifier)? @field.vis
                name: (field_identifier) @field.name
                type: (_) @field.type
              )
            )
        )
      ]
      QUERY
    end

    def run!
      super.each do |result|
        match = result.matches[0]
        name = match["type"]
        location = Location.new(
          result.path,
          name.range.start_point.row,
          name.range.start_point.column
        )
        type_name = name.text

        fields = {}
        result.matches.each do |match|
          vis = match["field.vis"].text if match.has_key? "field.vis"
          field_name = match["field.name"].text if match.has_key? "field.name"
          type = match["field.type"].text if match.has_key? "field.type"

          fields[field_name.to_sym] = Tabitha::Model::Field.new(vis, field_name.to_sym, type)
        end

        #Struct.create!(

        Type.struct(type_name, location, fields)
      end
    end
  end
end