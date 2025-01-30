module Tabitha
  module Engine
    class Location
      attr_accessor :file, :line, :column

      def initialize(file: nil, line: nil, column: nil)
        @file = file; @line = line; @column = column
      end

      # TODO: intern these. Later we can cache invalidate using weakrefs.
      def self.from(src: nil, node: nil)
        new(file: src, line: node.range.start_point.row, column: node.range.start_point.column)
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

      def hash
        [@file, @line, @column].hash
      end

      def ==(other)
        return if other.nil?
        @file == other.file && @line == other.line && @column == other.column
      end

      def eql?(other)
        return if other.nil?
        @file.eql?(other.file) && @line.eql?(other.line) && @column.eql?(other.column)
      end

      # Finds the nearest .git directory, then returns the relative path to the @file
      # from that directory.
      def relative_file
        git_dir = Pathname.new(@file).ascend.find { |p| p.join('.git').directory? }
        return @file unless git_dir
        Pathname.new(@file).relative_path_from(git_dir)
      end

      def to_uml
        "#{relative_file}:#{@line}"
      end

      alias to_s inspect
      def inspect(short: false)
        if short
          "#{@line}:#{@column}"
        else
          "#{@file}:#{@line}:#{@column} (#{object_id})"
        end
      end
    end
  end
end

