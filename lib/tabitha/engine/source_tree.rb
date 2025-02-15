module Tabitha
  module Engine
    # FIXME: This class is doing two things, it should be doing one.
    #
    # Right now it is managing crawling the source tree and building up an index of it, and it's responsible for owning
    # and managing the parser.
    class SourceTree
      class << self
        attr_reader :sources

        def clear!
          @source = {}
        end

        def load!(path)
          @sources ||= {}

          if File.directory?(path)
            Find.find(path) do |path|
              Find.prune if File.directory?(path) && File.basename(path).start_with?('.')
              next unless path.end_with? '.rs'
              @sources[path] = Entry.new(path)
            end
          else
            @sources[path] = Entry.new(path)
          end
        end

        def parse_with(parser)
          barrier = Async::Barrier.new
          Async do
            @sources.each do |path, entry|
              barrier.async do
                entry.parse_with(parser)
              end
            end

            barrier.wait
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
