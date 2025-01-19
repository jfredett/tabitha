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
        return if other.nil?
        @file == other.file && @line == other.line && @column == other.column
      end

      def eql?(other)
        return if other.nil?
        @file.eql?(other.file) && @line.eql?(other.line) && @column.eql?(other.column)
      end

      def inspect
        "#{@file}:#{@line}:#{@column} (#{object_id})"
      end
    end
  end
end

