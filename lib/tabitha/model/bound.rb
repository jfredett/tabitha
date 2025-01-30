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

      def ==(other)
        @bound == other.bound && @location == other.location
      end

      def eql?(other)
        return false unless other.is_a?(Bound)
        @bound.eql?(other.bound) && @location.eql?(other.location)
      end

      def hash
        [ @bound, @location ].hash
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

