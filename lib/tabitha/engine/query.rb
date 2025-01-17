module Tabitha
  module Engine
    class Query
      attr_reader :code

      def run!(src)
        if @target_code.nil?
          SourceTree.query(self.code)
        else
          @target_code.query(self.code)
        end
      end

      def on(code)
        # FIXME: This could be a treenode or text, if it's text we should parse it proactively, if it's a treenode we should
        # leave it alone, that way everything is always working on treenodes
        case code
        when String
          @target_code = SourceTree.parse(code)
        when TreeStand::Node
          @target_code = Entry.with_code(code)
        when TreeStand::Tree
          @target_code = Entry.with_code(code)
        else
          raise "Unknown code type #{code.class}"
        end
        self
      end

      class << self
        # Find all the queries in the queries directory, and load them into a registry by name. Queries can be either
        # `.scm` or .`.rb` files. `.rb` files are assumed to be ducks of the Query class (you can subclass it to get
        # most of the behavior for most queries). This will let you implement your own `#run!` method, and you can refer
        # to other queries by their name in the registry a la `Query[:NameOfQuery].run!`.
        #
        # This method loads all these queries into a flat registry, nested directories are allowed, but the namespace is
        # flat, So you will need to ensure that your queries have unique names across the whole `queries` directory and
        # it's children.
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
            @registry[klass_name] = klass.new
          end
        end

        def [](key)
          @registry[key]
        end
      end
    end
  end
end

