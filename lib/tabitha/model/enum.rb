module Tabitha
  module Model
    class Enum
      # TODO: Use forwardable.

      class Variant
        attr_reader :name, :location, :fields

        def initialize(name: nil, location: nil, fields: Set.new)
          @name = name
          @location = location
          @fields = fields
        end

        def <<(field)
          @fields << field
        end

        def ==(other)
          return false unless other.is_a?(Variant)
          @name == other.name && @fields == other.fields && @location == other.location
        end

        def eql?(other)
          self == other
        end

        def hash
          @name.hash ^ @fields.hash ^ @location.hash
        end
      end

      attr_reader :name, :location, :variants, :generics, :visibility # :impls

      # FIXME: most of this is a cut-paste from Struct, probably worth extracting a module
      
      def self.parse!(path, source)
        Tabitha::Engine::Query[:Enum].on(source).run!(path)
      end

      def self.clear!
        @registry = {}
      end

      def self.[](name)
        @registry[name.to_sym] if @registry&.key?(name.to_sym)
      end

      def self.create!(visibility: nil, name: nil, variants: Set.new, generics: Set.new, location: nil)
        return @registry[name] if @registry&.key?(name)
        @registry ||= {}
        @registry[name.to_sym] = new(visibility: visibility, name: name.to_sym, variants: variants, generics: generics, location: location)
        @registry[name.to_sym]
      end

      def initialize(visibility: nil, name: nil, variants: Set.new, generics: Set.new, location: nil)
        @visibility = visibility; @name = name; @location = location; @generics = generics; @variants = variants
      end

      def <<(variant)
        @variants << variant
      end
    end
  end
end



