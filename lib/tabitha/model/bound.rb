module Tabitha
  module Model
    # TODO: Rename this to `Bound` to match the treesitter output.
    class Bound
      attr_reader :bound, :location

      def initialize(bound: nil, location: nil)
        @bound = bound; @location = location
      end

      def self.from(node: nil, src: nil)
        location = Engine::Location::from(src: src, node: node)
        Model::Bound.new(bound: node.text.to_sym, location: location)
      end

      # OQ: I used to compare parents here as well, I don't think that's necessary? It may be that this should include
      # it, and hash should not. I only use the `parent` for the `name` sort, and probably that could be removed. It
      # would be nice if these were data classes that weren't necessarily aware of where they are in the tree. Not sure
      # how I want this to work just yet.
      def ==(other)
        @bound == other.bound && @location == other.location
      end

      def hash
        [ @bound, @location ].hash
      end

      def eql?(other)
        @bound.eql?(other.bound) && @location.eql?(other.location)
      end

      # As span always shows all it's bounds, if those are generically parameterized, we want to print the whole
      # type.
      def as_span
        bound.to_s
      end
      alias inspect as_span
      alias to_s as_span

      def bounded?
        @generics&.any?
      end

    end
  end
end

