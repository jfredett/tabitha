module Tabitha
  module Model
    class Fn

      attr_reader :location, :name, :params, :return_type, :modifier, :visibility

      # TODO: Wouldn't hate this being a registry class

      # OQ: params is maybe actually a list? I still need to enforce order and name uniqueness... probably needs to be
      # it's own type, for these purposes, we don't super care about order just yet.
      def initialize(location: nil, name: nil, params: Set.new, return_type: nil, modifier: nil, visibility: nil)
        @location = location
        @name = name
        @params = params
        @return_type = return_type
        @modifier = modifier
        @visibility = visibility
      end

      # Equality

      def ==(other)
        @location == other.location &&
          @name == other.name &&
          @params == other.params &&
          @return_type == other.return_type &&
          @modifier == other.modifier &&
          @visibility == other.visibility
      end

      def eql?(other)
        self == other
      end

      def hash
        @location.hash ^ @name.hash ^ @params.hash ^ @return_type.hash ^ @modifier.hash ^ @visibility.hash
      end
    end
  end
end
