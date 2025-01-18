# frozen_string_literal: true

require 'rspec/its'

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

SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter


require "tabitha"

# Helper method to create a location
def loc(line, col)
  Tabitha::Engine::Location.new(line: line, column: col)
end

FIXTURES_PATH = File.expand_path(File.join(__dir__, "fixtures"))

def fixture(*path)
  File.expand_path(File.join(FIXTURES_PATH, *path))
end

