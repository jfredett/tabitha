module Tabitha
  class Query
    class Fn < Tabitha::Engine::Query
      def code
        <<~QUERY
         (function_item (_) @trait.fn)
        QUERY
      end

      def run!(src = nil)
        # Implement the logic to parse function items from the source code.
        # For now, let's assume it returns a list of function names.
        src ||= Tabitha::Engine::SourceTree.parse!
        function_items = src.query(code).map do |match|
          match.named_captures['trait.fn'].text
        end
        function_items
      end
    end
  end
end
