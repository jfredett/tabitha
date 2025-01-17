module Tabitha
  module Engine
    class SourceTree
      class << self
        attr_reader :sources

        def load!(path)
          @sources = {}

          Find.find(path) do |path|
            Find.prune if File.directory?(path) && File.basename(path).start_with?('.')
            next unless path.end_with? '.rs'
            @sources[path] = Entry.new(path)
          end
        end

        def query(code)
          self.sources.map do |path, entry|
            # TODO: Move #query to Entry
            matches = entry.query(code)
            if matches.any?
              Result.new(path, entry.query(code))
            else
              nil
            end
          end.reject(&:nil?).flatten
        end

        def parse(code)
          self.parser.parse_string(code)
        end

        def parser
          return @parser if @parser

          ::TreeStand.configure do
            config.parser_path = '.parsers'
          end

          @parser = TreeStand::Parser.new('rust')
        end
      end
    end
  end
end
