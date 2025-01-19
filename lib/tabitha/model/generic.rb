module Tabitha
  module Model
    class Generic
      attr_accessor :name, :constraints, :location, :parent

      def initialize(name: nil, constraints: {}, location: nil, parent: nil)
        @name = name; @constraints = constraints; @location = location; @parent = parent
      end


      def ==(other)
        @name.to_sym == other.name.to_sym && @constraints == other.constraints && @location == other.location && @parent == other.parent
      end

      # def inspect
      #   constraints = ": #{@constraints.map(&:trait).join(" + ")}" if not @constraints.empty?
      #   "#{@name.to_s}#{constraints} (#{location.inspect} G#id #{object_id} P#id #{parent.object_id})"
      # end

    end
  end
end

