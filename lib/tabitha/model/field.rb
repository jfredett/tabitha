module Tabitha
  module Model
    class Field
      attr_reader :visibility, :name, :location
      attr_accessor :type

      def initialize(visibility: nil, name: nil, type: nil, location: nil)
        @visibility = visibility&.to_sym; @name = name; @type = type; @location = location
      end

      def is_ordered_field?
        @name.nil?
      end

      def to_uml
        name = "#{@name}: " unless @name.nil?
        "#{@visibility}#{" " unless @visibility.nil?}#{name}#{@type}"
      end

      def ==(other)
        @visibility == other.visibility && @name.to_sym == other.name.to_sym && @type.to_sym == other.type.to_sym && @location == other.location
      end

      def hash
        # OQ: I learned this way of calculating the hash as a superstition against the more obvious xor-of-the-hashes
        # way. I don't think it's any _different_ (that is, I think this is equivalent to the xor way), but I think it
        # might be slower? faster? Honestly not sure, maybe benchmark it someday.
        [@visibility, @name, @type, @location].hash
      end

      def eql?(other)
        @visibility.eql?(other.visibility) && @name.to_sym.eql?(other.name.to_sym) && @type.to_sym.eql?(other.type.to_sym) && @location.eql?(other.location)
      end

      def to_uml(short_location: false)
        vis = "#{@visibility} " unless @visibility.nil?
        "#{vis}#{name} : #{@type}"
      end

      def inspect
        vis = "#{@visibility} " unless @visibility.nil?
        "##{vis}#{name} : #{@type} (#{location.inspect(short: true)})"
      end
    end
  end
end

