module Tabitha
  module Model
    class Struct
      attr_accessor :visibility, :name, :fields, :location, :fields, :generics

      # TODO: have this take a path location, and use kwargs
      def self.parse!(path, source)
        Tabitha::Engine::Query[:Struct].on(source).run!(path)
      end

      def self.clear!
        @registry = {}
      end

      def self.[](name)
        @registry[name.to_sym] if @registry&.key?(name.to_sym)
      end

      def self.create!(name: nil, generics: {}, fields: {}, location: nil)
        return @registry[name] if @registry&.key?(name)
        @registry ||= {}
        @registry[name.to_sym] = new(name: name.to_sym, generics: generics, location: location, fields: fields)
      end

      def initialize(name: nil, location: nil, generics: {}, fields: {})
        @name = name; @location = location; @generics = generics; @fields = fields
      end



      def to_uml
        # in:
        #
        # struct name<generic_span> {
        #   field_section
        # }
        #
        # The `generic_section` is a list of bounds, which would fit in a `where` clause or in the struct name as
        # type bounds, this is going to output all the constrain info in the section, and just leave bare generics
        # in the struct declaration.
        #
        # the `link_section` contains links to other types from the perspective of this type. Since it refers to types
        # that may not exist, be careful using this.
        #
        # TODO: The `impl` section
        #
        # This section will collect all the impls, and break them up by containing file. It'll then show all the
        # methods it finds there under another subsection of the diagram.
        #

        field_section = "" unless self.zst?
        impl_section = "" if false # TODO: Impl...
        link_section = "" if false # TODO: ibid

        # TODO: Poor man's ERB
        # vvvvvvvvvvvvvvvvvvvv
        <<~UML
        struct #{name}#{generic_span(with_bounds: false)} {
        #{".. where .." if self.generics?}
        #{generic_span(with_bounds: true)}
        #{".. fields .." unless self.zst?}
        #{field_section}
        #{".. impls .." if false}
        #{impl_section}
        }

        #{struct_trait_impl_section if false}
        #{generic_class_section if false}
        #{generic_trait_impl_section if false}
        #{link_section if false}
        UML
      end

      def generic_span(with_bounds: false)
        return unless self.generics?

        generics.values
                .sort_by(&:name)
                .map { |v| v.as_span(with_bounds: with_bounds) }
                .join(', ')
      end

      def generics?
        @generics&.any?
      end

      def constrained?
        generics? and generics.values.any?(&:constrained?)
      end

      def generically_constrained?
        generics? and constrained? and generics.values.any?(&:generic_bounds?)
      end

      def zst?
        @fields.empty?
      end

    end
  end
end
