module Tabitha
  module Model
    class Constraint
      attr_reader :name, :trait, :generics, :location
      attr_accessor :parent

      def initialize(name: nil, trait: nil, generics: nil, location: nil, parent: nil)
        @name = name; @trait = trait; @generics = generics; @location = location
      end

      def ==(other)
        @name.to_sym == other.name.to_sym && @trait.to_sym == other.trait.to_sym && @generics == other.generics && @location == other.location && @parent == other.parent
      end

      # def inspect
      #   generics = "<#{@generics.map(&:inspect).join(", ")}>" if not @generics.empty?
      #   traitname = @trait.name if @trait.respond_to?(:name)
      #   traitname ||= @trait
      #   "#{@name}: #{traitname.to_sym}#{generics}"
      # end
    end
  end
end

