module Tabitha
  module Model
    class Generic
      attr_accessor :name, :constraints, :location, :parent

      # TODO: Rename constraints -> bounds for parity w/ treesitter
      def initialize(name: nil, constraints: {}, location: nil, parent: nil)
        @name = name; @constraints = constraints; @location = location; @parent = parent
      end

      def as_span(with_constraints: false)
        if with_constraints and constrained?
          "#{name} : #{bound}"
        else
          name.to_s
        end
      end

      def ==(other)
        @name.to_sym == other.name.to_sym && @constraints == other.constraints && @location == other.location && @parent == other.parent
      end

      FILTERED_FIELD_TYPES = %w(u8 u16 u32 u64 i8 i16 i32 i64 isize usize bool str char String () Self)

      def concrete?
        # TODO: Replace this with an index lookup
        Tabitha::Model::Type::FILTERED_FIELD_TYPES.include?(@name.to_s) or not Tabitha::Model::Struct[@name].nil?
      end

      def constrained?
        @constraints&.any?
      end

      # The sum of all bounds applied to this type
      def bound
        @constraints.values.sort_by(&:name).map(&:as_span).join(" + ")
      end

      # NOTE: I'm only going one layer deep until I find a reason to go deeper. This begs for some general recursive
      # solution but I am not sure where it's hiding.
      def generic_constraints?
        inner_generics_list&.any?
      end

      def inner_generics_list
        @constraints.values.filter_map do |c|
          c.generics.values if c.generics?
        end.compact.flatten
      end
    end
  end
end
