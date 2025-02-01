# frozen_string_literal: true


#TODO: Issue when parsing types w/ lots of generics (like Familiar), check on that.

require 'async'
require 'async/barrier'
require 'find'
require 'pry'
require 'tree_sitter'
require 'tree_stand'

require_relative "tabitha/version"
require_relative 'tabitha/util'
require_relative 'tabitha/engine'
require_relative 'tabitha/model'
#require_relative 'tabitha/uml'

require 'monkey_patches'

module Tabitha
  class Error < StandardError; end

  QUERY_PATH = File.expand_path(File.join(__dir__, "tabitha", "queries"))


  def self.key_for(path)
    snake_case = File.basename(path).gsub('.scm', '').gsub('.rb', '')
    self.snake_to_camel(snake_case)
  end

  # "camel_case" -> :CamelCase
  def self.snake_to_camel(snake_case)
    snake_case.split('_').map(&:capitalize).join.to_sym
  end

  # This is called at require-time to load all the queries into the registry. This also
  # `require`s everything in that directory.
  def self.init!
    Engine::Query.load!
  end

  # Run on a particular source path, creating a source-tree.
  # TODO: Better name
  def self.run!(source_path)
    # TODO: Marshall this and only load if the SHA has changed. -- Make a Marshall class, probably I should name this
    # something, damn it I'm getting attached.
    SourceTree.load!(source_path)

    barrier = Async::Barrier.new
    Async do
      barrier.async do
        STDERR.puts "Parsing Structs..."
        Query[:Struct].run!
      end

      # barrier.async do
      #   STDERR.puts "Parsing Enums..."
      #   Query[:Enum].run!
      # end

      # barrier.async do
      #   STDERR.puts "Parsing Traits..."
      #   Query[:Trait].run!.each do |result|
      #     match = result.matches[0]
      #     name = match["trait.name"]
      #     location = Location.new(
      #       result.path,
      #       name.range.start_point.row,
      #       name.range.start_point.column
      #     )
      #     Type.trait(name.text, location)
      #   end
      # end

      barrier.wait

      STDERR.puts "Finding APIs..."
      Type.types.each do |ty|
        barrier.async do
          STDERR.puts "  #{ty.kind} #{ty.name}"
          ty.find_apis!
        end
      end

      barrier.wait

      puts "@startuml"
      Type.types.each do |ty|
        barrier.async do
          puts ty.to_uml
          puts ""
        end
      end

      barrier.wait

      Type.types.each do |ty|
        barrier.async do
          puts ty.uml_links
          puts ""
        end
      end
      puts "@enduml"

      barrier.wait
    end

    STDERR.puts "Done!"
  end
end


# OQ: I don't know if eager loading is correct here, but I'm going to leave it for now as laziness is usually harder 
# to reason about.
Tabitha.init!
