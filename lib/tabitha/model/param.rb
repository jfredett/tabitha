module Tabitha
  module Model
    class Param
      attr_reader :location, :name, :type

      def initialize(location: nil, name: nil, type: nil)
        @name = name
        @type = type
        @location = location
      end

      def ==(other)
        @location == location && @name == other.name && @type == other.type
      end

      def eql?(other)
        self == other
      end

      def hash
        @location.hash ^ @name.hash ^ @type.hash
      end
    end
  end
end
