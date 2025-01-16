module Tabitha
  module Model
    class Struct
      attr_reader :modifier, :visibility, :name, :fields, :params, :return_type, :location



      def self.create!(name, location, body)
        new(name, location, body)

      end

      def fields
        @fields unless @fields.nil?

        Query[:Fields].on(@body).run!.each do |result|
          Field.from_result!(result)
        end
      end

      private

      def initialize(name, location, body)
        @name = name; @location = location; @body = body
      end

      attr_reader :body

    end
  end
end
