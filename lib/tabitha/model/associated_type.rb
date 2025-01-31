module Tabitha
  module Model
    class AssociatedType
      attr_reader :location, :name, :type, :bounds

      def initialize(location: nil, name: nil, default: nil, bounds: Set.new)
        @location = location
        @name = name
        @default = default 
        @bounds = bounds
      end

      def ==(other)
        @location == other.location && @name == other.name && @type == other.type && @bounds == other.bounds
      end

      def eql?(other)
        self == other
      end

      def hash
        @location.hash ^ @name.hash ^ @type.hash ^ @bounds.hash
      end
    end
  end
end
