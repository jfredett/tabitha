module Tabitha
  module Model
    class Trait
      attr_accessor :location, :name, :generics, :trait_items, :associated_types

      # TODO: have this take a path location, and use kwargs
      def self.parse!(path, source)
        Tabitha::Engine::Query[:Trait].on(source).run!(path)
      end

      def self.clear!
        @registry = {}
      end

      def self.[](name)
        @registry[name.to_sym] if @registry&.key?(name.to_sym)
      end

      def self.create!(location: nil, name: nil, generics: Set.new, trait_items: Set.new, associated_types: Set.new)
        return @registry[name] if @registry&.key?(name)
        @registry ||= {}
        @registry[name.to_sym] = new(location: location, name: name, generics: generics, trait_items: trait_items, associated_types: associated_types)
        @registry[name.to_sym]
      end

      def initialize(location: nil, name: nil, generics: Set.new, trait_items: Set.new, associated_types: Set.new)
        @location = location
        @name = name
        @generics = generics
        @trait_items = trait_items
        @associated_types = associated_types
      end
    end
  end
end
