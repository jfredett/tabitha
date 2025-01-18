module Tabitha
  module Engine
    class Entry
      attr_accessor :path

      def content
        return @content unless @content.nil?
        @content ||= SourceTree.parse(File.read(@path))
      end

      def query(code)
        content.query(code)
      end

      def parse_with(parser)
        parser.parse!(@path, content)
      end

      def self.with_code(code)
        new(nil, code)
      end

      def initialize(path, code = nil)
        @path = path
        case code
        when String
          @content = SourceTree.parse(code)
        when TreeStand::Node, TreeStand::Tree
          @content = code
        when NilClass
          @content = nil
        else
          raise ArgumentError, "code must be a String or TreeStand::Node, got #{code.class}"
        end
      end
    end
  end
end
