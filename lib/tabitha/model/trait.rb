module Tabitha
  module Model
    class Trait
      attr_accessor :location, :name, :generics, :trait_items, :associated_types

      alias primary_key name

      extend Tabitha::Util::Registry

      # TODO: have this take a path location, and use kwargs
      def self.parse!(path, source)
        Tabitha::Engine::Query[:Trait].on(source).run!(path)
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
