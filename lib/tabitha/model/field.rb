module Tabitha
  module Model
    class Field
      attr_reader :visibility, :name, :location
      attr_accessor :parent, :type

      def initialize(parent: nil, visibility: nil, name: nil, type: nil, location: nil)
        @parent = parent ; @visibility = visibility; @name = name; @type = type; @location = location
      end

      def is_ordered_field?
        @name.nil?
      end

      def to_uml
        name = "#{@name}: " unless @name.nil?
        "#{@visibility}#{" " unless @visibility.nil?}#{name}#{@type}"
      end

      def ==(other)
        @parent == other.parent && @visibility == other.visibility && @name.to_sym == other.name.to_sym && @type.to_sym == other.type.to_sym && @location == other.location
      end

      def inspect
        vis = "#{@vis} " unless @vis.nil?
        "#{parent.name}##{vis}#{name} : #{@type} (#{@location.inspect}, F#id #{object_id} P#id #{parent.object_id})"
      end
    end
  end
end

