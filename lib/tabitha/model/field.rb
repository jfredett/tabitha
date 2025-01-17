module Tabitha
  module Model
    class Field
      attr_reader :vis, :name, :location
      attr_accessor :parent, :type

      def initialize(parent: nil, vis: nil, name: nil, type: nil, location: nil)
        @parent = parent ; @vis = vis; @name = name; @type = type; @location = location
      end

      def is_ordered_field?
        @name.nil?
      end

      def to_uml
        name = "#{@name}: " unless @name.nil?
        "#{@vis}#{" " unless @vis.nil?}#{name}#{@type}"
      end

      def ==(other)
        @parent == other.parent && @vis == other.vis && @name == other.name && @type == other.type && @location == other.location
      end
    end
  end
end

