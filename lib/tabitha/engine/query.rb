module Tabitha
  module Engine
    class Query
      attr_reader :src, :code

      def initialize(path)
        @src = path
      end

      def run!
        if @target_code.nil?
          SourceTree.query(self.code)
        else
          Entry.with_code(@target_code).query(self.code)
        end
      end

      def on(code)
        @target_code = code
        self
      end

      def key
        Tabitha.key_for(@src)
      end

      class << self
        # Find all the queries in the queries directory, and load them into a registry by name. Queries can be either `.scm`
        # or .`.rb` files. `.scm` files are assumed to be treesitter queries to be executed on the source tree and return
        # their matches from the #run! method.
        #
        # `.rb` files are assumed to be ducks of the Query class (you can subclass it to get most of the behavior for most
        # queries). This will let you implement your own `#run!` method, and you can refer to other queries by their name in
        # the registry a la `Query[:NameOfQuery].run!`.
        #
        # This method loads all these queries into a flat registry, nested directories are allowed, but the namespace is flat,
        # So you will need to ensure that your queries have unique names across the whole `queries` directory and it's
        # children.
        #
        # This loads all the queries underneath the `Query` constant to avoid name collisions.
        def load!
          @registry ||= {}
          Find.find(Tabitha::QUERY_PATH) do |path|
            Find.prune if File.directory?(path) && File.basename(path).start_with?('.')
            next if File.directory?(path)

            require path
            klass_name = Tabitha::key_for(path)
            klass = Tabitha::Query.const_get(klass_name)
            @registry[klass_name] = klass.new(path)
          end
        end

        def [](key)
          @registry[key]
        end
      end
    end
  end
end

