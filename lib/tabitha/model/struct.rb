module Tabitha
  module Model
    class Struct
      attr_reader :modifier, :visibility, :name, :fields, :generics, :location

      # TODO: have this take a path location, and use kwargs
      def self.parse!(path, source)
        Tabitha::Engine::Query[:Struct].on(source).run!(path)
      end

      def self.create!(name: nil, generics: nil, location: nil, body: nil)
        return @registry[name] if @registry&.key?(name)
        @registry ||= {}
        @registry[name.to_sym] = new(name: name.to_sym, generics: generics, location: location, body: body)
      end

      def self.[](name)
        @registry[name.to_sym] if @registry&.key?(name.to_sym)
      end

      def fields
        @fields unless @fields.nil?
        @fields = Tabitha::Engine::Query[:Field].on(@body).run!.each do |field|
          field.location.file = @location.file
          field.parent = self
        end
      end

      private

      attr_reader :body

      def initialize(name: nil, location: nil, generics: nil, body: nil)
        @name = name; @location = location; @generics = generics; @body = body
      end
    end
  end
end
