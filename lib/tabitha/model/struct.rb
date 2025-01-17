module Tabitha
  module Model
    class Struct
      attr_reader :modifier, :visibility, :name, :fields, :params, :return_type, :location

      def self.parse!(source)
        Tabitha::Engine::Query[:Struct].on(source).run!
      end

      def self.create!(name, location, body)
        return @registry[name] if @registry&.key?(name)
        @registry ||= {}
        @registry[name.to_sym] = new(name.to_sym, location, body)
      end

      def self.[](name)
        @registry[name.to_sym] if @registry&.key?(name.to_sym)
      end

      def fields
        @fields unless @fields.nil?

        @fields = Tabitha::Engine::Query[:Fields].on(@body).run!.map { |result| Field.from_result!(result) }
      end

      private

      attr_reader :body

      def initialize(name, location, body)
        @name = name; @location = location; @body = body
      end
    end
  end
end
