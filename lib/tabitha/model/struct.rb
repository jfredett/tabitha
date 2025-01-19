module Tabitha
  module Model
    class Struct
      attr_accessor :visibility, :name, :fields, :location, :fields, :generics

      # TODO: have this take a path location, and use kwargs
      def self.parse!(path, source)
        Tabitha::Engine::Query[:Struct].on(source).run!(path)
      end

      def self.clear!
        @registry = {}
      end

      def self.create!(name: nil, generics: {}, fields: {}, location: nil)
        return @registry[name] if @registry&.key?(name)
        @registry ||= {}
        @registry[name.to_sym] = new(name: name.to_sym, generics: generics, location: location, fields: fields)
      end

      def self.[](name)
        @registry[name.to_sym] if @registry&.key?(name.to_sym)
      end

      private

      def initialize(name: nil, location: nil, generics: {}, fields: {})
        @name = name; @location = location; @generics = generics; @fields = fields
      end
    end
  end
end
