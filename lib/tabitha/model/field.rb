module Tabitha
  module Model
    class Field
      attr_reader :vis, :name, :type

      # TODO: Promote Type to an object reference back into the Type pool.
      def initialize(vis, name, type)
        @vis = vis; @name = name; @type = type
      end

      def is_ordered_field?
        @name.nil?
      end

      def to_uml
        name = "#{@name}: " unless @name.nil?
        "#{@vis}#{" " unless @vis.nil?}#{name}#{@type}"
      end
    end
  end
end

