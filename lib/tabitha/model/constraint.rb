module Tabitha
  module Model
    # TODO: Rename this to `Bound` to match the treesitter output.
    class Constraint
      attr_reader :bound, :location
      attr_accessor :parent

      def initialize(bound: nil, location: nil, parent: nil)
        @bound = bound; @location = location ; @parent = parent
      end

      def ==(other)
        @bound == other.bound && @location == other.location && @parent == other.parent
      end

      # As span always shows all it's bounds, if those are generically parameterized, we want to print the whole
      # type.
      def as_span
        bound.to_s
      end

      def name
        @parent.name
      end

      def bounded?
        @generics&.any?
      end
    end
  end
end

