module Tabitha
  class Query
    class Fn < Tabitha::Engine::Query
      def code
        <<~QUERY
         (function_item (_) @trait.fn)
        QUERY
      end


      def run!(src = nil)
      end
    end
  end
end
