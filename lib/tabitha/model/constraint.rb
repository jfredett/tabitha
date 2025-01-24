module Tabitha
  module Model
    class Constraint
      attr_reader :name, :trait, :generics, :location
      attr_accessor :parent

      # TODO: Generics should really just be 'inner type', and we capture it whole. We can tease it apart in a future
      # iteration to get more interesting connections into the graph.
      # TODO: drop #name, it's not needed, accessible by #parent.name
      def initialize(name: nil, trait: nil, generics: {}, location: nil, parent: nil)
        @name = name; @trait = trait; @generics = generics; @location = location
      end

      def ==(other)
        @name.to_sym == other.name.to_sym && @trait.to_sym == other.trait.to_sym && @generics == other.generics && @location == other.location && @parent == other.parent
      end

      # As span always shows all it's constraints, if those are generically parameterized, we want to print the whole
      # type.
      def as_span
        return "#{trait}" unless generics?

        "#{trait}<#{generics_list.join(", ")}>"
      end

      # This is wrong, it should be inner_type, and this is not the right way to print that type I think
      def generics_list
        @generics.values.flat_map do |g|
          if g.is_a? Symbol
            [ g ]
          else
            [ g,
              g.constraint_list.map(&:generics) ]
          end
        end
      end

      def generics?
        @generics&.any?
      end
    end
  end
end

