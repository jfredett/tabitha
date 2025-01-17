module Tabitha
  module Engine
    class Result
      attr_accessor :path, :matches

      def initialize(path, matches)
        @path = path
        @matches = matches
      end
    end
  end
end
