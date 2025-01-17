module Tabitha
  module Engine
    class Location
      attr_accessor :file, :line, :column

      def initialize(file: nil, line: nil, column: nil)
        @file = file; @line = line; @column = column
      end

      def has_file?
        !@file.nil?
      end

      def has_line?
        !@line.nil?
      end

      def has_column?
        !@column.nil?
      end

      def ==(other)
        @file == other.file && @line == other.line && @column == other.column
      end
    end
  end
end

