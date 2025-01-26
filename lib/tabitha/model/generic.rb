module Tabitha
  module Model
    class Generic
      attr_accessor :name, :bounds, :location

      # TODO: constraints should be a set
      def initialize(name: nil, bounds: Set.new, location: nil)
        @name = name; @bounds = bounds; @location = location
      end

      def as_span(with_bounds: false)
        if with_bounds and bounded?
          "#{name} : #{bound}"
        else
          name.to_s
        end
      end

      def ==(other)
        @name.to_sym == other.name.to_sym && @bounds == other.bounds && @location == other.location
      end

      def hash
        [ @name, @bounds, @location, ].hash
      end

      def eql?(other)
        @name.eql?(other.name) && @bounds.eql?(other.bounds) && @location.eql?(other.location)
      end

      FILTERED_FIELD_TYPES = %w(u8 u16 u32 u64 i8 i16 i32 i64 isize usize bool str char String () Self)

      def concrete?
        # TODO: Replace this with an index lookup
        Tabitha::Model::Type::FILTERED_FIELD_TYPES.include?(@name.to_s) or not Tabitha::Model::Struct[@name].nil?
      end

      def bounded?
        @bounds&.any?
      end

      # The sum of all bounds applied to this type
      def bound
        @bounds.map(&:as_span).join(" + ")
      end

      # NOTE: I'm only going one layer deep until I find a reason to go deeper. This begs for some general recursive
      # solution but I am not sure where it's hiding.
      def generic_bounds?
        inner_generics_list&.any?
      end

      def inner_generics_list
        @bounds.values.filter_map do |c|
          c.generics.values if c.generics?
        end.compact.flatten
      end
    end
  end
end
