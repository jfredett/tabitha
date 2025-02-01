module Tabitha
  module Model
    class Struct
      attr_accessor :visibility, :name, :fields, :location, :generics
      alias primary_key name

      # TODO: have this take a path location, and use kwargs
      def self.parse!(path, source)
        Tabitha::Engine::Query[:Struct].on(source).run!(path)
      end

      extend Tabitha::Util::Registry

      def initialize(visibility: nil, name: nil, location: nil, generics: Set.new, fields: Set.new)
        @visibility = visibility; @name = name; @location = location; @generics = generics; @fields = fields
      end

      def impls
        Tabitha::Model::Impl.where { |e| e.struct == self }
      end

      def hash
        [@visibility, @name, @location, @generics, @fields].hash
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

        impl_section = "" if false # TODO: Impl...
        link_section = "" if false # TODO: ibid

        # TODO: Poor man's ERB
        # vvvvvvvvvvvvvvvvvvvv
        <<~UML
        struct #{name}<#{generic_span(with_bounds: false)}> {
          ./#{location.to_uml}
          #{".. where .." if self.generics?}
          #{generic_span(with_bounds: true)}
          #{".. fields .." unless self.zst?}
          #{field_span}
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

        generics.sort_by(&:name)
                .map { |v| v.as_span(with_bounds: with_bounds) }
                .join(', ')
      end

      def field_span
        @fields.map { |f| f.to_uml }.join("\n  ") unless self.zst?
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
