module Tabitha
  module Engine
    class Entry
      attr_accessor :path


      def content
        @content ||= SourceTree.parse(File.read(@path))
      end

      def query(code)
        content.query(code)
      end

      def self.with_code(code)
        new(nil, code)
      end

      def initialize(path, code = nil)
        @path = path
        @content = SourceTree.parse(code)
      end
    end
  end
end
