module Tabitha
  module Model
    class Impl
      attr_reader :location, :fns # TODO: Impl-associated constants (e.g., impl Foo { pub const BAR: i32 = 42; }) is different than an `fn`)

      @registry ||= Set.new

      def self.[](name)
      end

      def self.create!(struct: nil, location: nil, fns: Set.new)
        @registry << new(struct: struct, location: location, fns: fns)
      end

      def self.where(&block)
        @registry&.filter(&block)
      end

      def self.parse!(path, source)
        Tabitha::Engine::Query[:Impl].on(source).run!(path)
      end

      def initialize(struct: nil, location: nil, fns: Set.new)
        @struct = struct ; @location = location ; @fns = fns
      end
    end
  end
end
