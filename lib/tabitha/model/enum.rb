module Tabitha
  module Model
    class Enum
      attr_reader :name, :location, :kind, :variants

      def initialize(name, location, kind)
        @name = name
        @location = location
        @kind = kind
        @variants = []
      end

      def <<(variant)
        @variants << variant
      end
    end

    class Variant
      # A variant can have empty fields, ordered fields, or named fields. The last essentially makes a dynamic struct.
      attr_reader :name, :location, :fields

      def empty_variant?
        @fields.empty?
      end

      def ordered_field_variant?
        !@fields.empty? && @fields.all(&:is_ordered_field?)
      end

      def named_field_variant?
        !@fields.empty? && @fields.all? { |field| !field.is_ordered_field? }
      end
    end
  end
end



