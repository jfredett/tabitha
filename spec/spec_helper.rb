# frozen_string_literal: true

require 'rspec/its'
require 'super_diff/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.formatter = :progress

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.start do
  enable_coverage :branch
  add_filter "/spec/"
end
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter


require "tabitha"

# Helper method to create a location
def loc(line, col, file: nil)
  Tabitha::Engine::Location.new(file: file, line: line, column: col)
end

def scratch_loc(line, col)
  STDERR.puts "DEPRECATED, use #struct_loc instead\n -> #{caller[0]}"
  struct_loc(line, col)
end

def struct_loc(line, col)
  loc(line, col, file: fixture("struct.rs"))
end

def enum_loc(line, col)
  loc(line, col, file: fixture("enum.rs"))
end

FIXTURES_PATH = File.expand_path(File.join(__dir__, "fixtures"))

def fixture(*path)
  File.expand_path(File.join(FIXTURES_PATH, *path))
end

