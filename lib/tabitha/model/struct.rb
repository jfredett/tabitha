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

      def self.create!(name: nil, generics: {}, fields: {}, location: nil)
        return @registry[name] if @registry&.key?(name)
        @registry ||= {}
        @registry[name.to_sym] = new(name: name.to_sym, generics: generics, location: location, fields: fields)
      end

      def self.[](name)
        @registry[name.to_sym] if @registry&.key?(name.to_sym)
      end

      def to_uml
        # in:
        #
        # struct name<generic_span> {
        #   field_section
        # }
        #
        # The `generic_section` is a list of constraints, which would fit in a `where` clause or in the struct name as
        # type constraints, this is going to output all the constrain info in the section, and just leave bare generics
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

        # if there are generics, then this should look like `<T, U, V>`, no constraints here.
        generic_span = "<#{generics.map({ |g| g.name }).join(", ")}>" if self.generics?
        generic_section = generics.map do |g|
          bounds = ": #{g.bounds.values.map(&:inspect).join(' + ')}" if g.has_bounds?
          "#{g.name}#{bounds}"
        end.join("\n")
        field_section = "" unless self.zst?
        impl_section = "" if false # TODO: Impl...
        link_section = "" if false # TODO: ibid

        # TODO: Poor man's ERB
        # vvvvvvvvvvvvvvvvvvvv
        <<~UML
        struct #{name}#{generic_span} {
          #{".. where .." if self.generics?}
          #{generic_section}
          #{".. fields .." unless self.zst?}
          #{field_section}
          #{".. impls .." if false}
          #{impl_section}
        }

        #{link_section if false}
        UML
      end

      private

      def initialize(name: nil, location: nil, generics: {}, fields: {})
        @name = name; @location = location; @generics = generics; @fields = fields
      end
    end
  end
end
