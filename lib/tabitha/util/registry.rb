module Tabitha
  module Util
    # This creates a 'registry' for instances of the class. This is useful for a situation where you need to model a
    # bunch of actual objects that are convenient to sort by some key. It expects that instances of the extending
    # class have a `#primary_key`, which is used to maintain a primary index of all the instances that are `#register!`ed
    #
    # This index can be queried with `#[]` to get an instance by its primary key.
    module Registry
      def register!(instance)
        registry[instance.primary_key] = instance
      end

      def [](key)
        @registry[key]
      end

      def clear!
        @registry = {}
      end

      def registry
        @registry ||= {}
      end

      def create!(**args)
        new(**args).tap { |instance| register!(instance) }
      end
    end
  end
end
