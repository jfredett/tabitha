module Tabitha
  module Util
    # A `thetical` is the content between two `paren`s.
    # <L_PAREN><THETICAL><R_PAREN>
    #
    # Practically, it is a variant of `Set` that allows additional constraints to be observed when adding elements. For
    # instance, a parameter list in Rust:
    #
    # 1. Has unique names for all named parameters.
    # 2. Has a type specified for each non-self parameter
    # 3. May include exactly one `self` parameter. Which may be borrowed or have other modifiers.
    # 4. May refer to generics in the function signature.
    # 5. Must preserve the order of the parameters for faithful reprinting
    #
    # and more.
    #
    # These are easy to express in code, but it would be untidy to have lots of little functions trying to enforce that
    # over `Set`. Thus, `Thetical`.
    #
    # @example
    #
    # ParamSet = Thetical.new_klass do |th|
    #   # A simple constraint that ensures that, when `<<` is called, the item has a name, or is `self`
    #   th.constrain!(:<<) do |item|
    #     not item.name.nil? unless item.self_parameter?
    #   end
    #
    #   # This is a uniqueness constraint on items. The arity of the block is used to determine what is provided, by
    #   # default it will always return _distinct_ items. This is also a global constraint, meaning it is checked on
    #   # every method call. These can be expensive, so use them sparingly.
    #   th.constrain! do |left, right|
    #     left.name != right.name
    #   end
    #
    #   th.constrain! do |left|
    #     self.each do |right|
    #       # This _will not_ do the distinctness filtering for you, so you must do it yourself.
    #       # self will be the underlying set instance, so you can just do internal iteration. Again, you're responsible
    #       # for your own performance here, you can make this a very slow object without even trying.
    #     end
    #   end
    #
    #   th.constrain!(:<<) do |item|
    #     item.type.nil? unless item.self_parameter?
    #     # an optional description can be added for error reporting when the constraint fails
    #   end.describe("Non-self parameters must have defined types.")
    #   # This will raise an error if the constraint fails, and the description will be included in the error message.
    #   # by default it just says "Constraint failed."
    #
    #   # Some common constraints are predefined, these are exacty as above, just a convenience.
    #   th.has_exactly_one! { |item| item.self_parameter? }
    # end
    #
    # paramset = ParamSet.new
    #
    # # or
    #
    # paramset = ParamSet[...]
    #
    # # just like `Set`, but now when you add stuff it verifies all the constraints you've set.
    #
    #
    # NOTE: It might be wise to do a two-phase thing, let a bunch of stuff get added, then do the constraint check all
    # at once. This means I won't be able to respond right away to every add though with error or not. That could get
    # weird. Maybe make it optional, some kind of transaction block? e.g., `paramset.transaction { |ps| ps << ... }` --
    # constraints checked at the end of the block?
    module Thetical
      def self.define(&block)
        Class.new(Template, &block)
      end

      class Template
        def initialize(*args)
          @set = Set.new(*args)
        end

        def respond_to_missing?(name, include_private = false)
          @set.respond_to?(name) || super
        end

        include Enumerable
        extend Forwardable

        def_delegators :@set, :each, :empty?, :size, :include?, :to_a

        # yields all distinct pairs of items in the set, will admit both orderings of a pair. e.g., [a, b] and [b, a].
        # I'd say this is because of not wanting to assume your constraint is commutative, but I'm actually just lazy.
        def distinct_pairs(&block)
          @set.map do |left|
            @set.map do |right|
              next if left == right
              [left, right]
            end
          end.flatten(1).compact.each(&block)
        end

        # true if all distinct pairs satisfy the block
        def all_distinct_pairs?(&block)
          distinct_pairs.all?(&block)
        end

        # true if any distinct pair satisfies the block
        def any_distinct_pair?(&block)
          distinct_pairs.any?(&block)
        end

        def method_missing(name, *args, &block)
          @set.send(name, *args, &block)

          self.class.hooks.each do |hook|
            next unless hook.applies_to?(name)
            if hook.mode == :reject
              raise "Constraint: `#{hook.name}` failed." if hook.call(self)
            else
              raise "Constraint: `#{hook.name}` failed." unless hook.call(self)
            end
          end
        end

        class Constraint
          attr_reader :name, :methods, :mode

          def initialize(name: nil, methods: [], mode: :reject, &block)
            @name = name
            @methods = methods
            @mode = mode
            @block = block
          end

          extend Forwardable

          def_delegators :@block, :arity

          def call(thetical)
            case arity
            when 0
              thetical.instance_exec(&@block)
            when 1
              thetical.all? { |item| thetical.instance_exec(item, &@block) }
            when 2
              thetical.all_distinct_pairs? { |left, right| thetical.instance_exec(left, right, &@block) }
            else
              raise "Invalid arity (#{arity}) for constraint block."
            end
          end

          def describe(description)
            @description = description
          end

          def applies_to?(method)
            @methods.empty? || @methods.include?(method)
          end
        end

        class << self
          def hooks
            @hooks ||= []
          end

          # #constrain! is a method that allows you to add a constraint to the thetical. This constraint will be checked
          # in two cases:
          #
          # 1. If no args are given, then the constraint will be checked on every method call via a method missing hook.
          # 2. If args are given, they are assumed to be method names, and the constraint will only be checked _after_
          #    those methods are called.
          #
          # If a constraint fails, an error will be raised with the message "Constraint failed."
          #
          # constraints are default-reject (and #reject! is an alias for #constrain!). You can invert that logic with
          # the #accept! method.
          #
          # This method should generally not be used directly, use `#reject!` or `#accept!` instead.
          def constrain!(methods:, name:, mode:,  &block)
            thunk = Constraint.new(methods: methods, name: name, mode: mode, &block)

            self.hooks << thunk

            thunk
          end

          def reject!(methods: [], name: nil, &block)
            constrain!(methods: methods, name: name, mode: :reject,  &block)
          end

          # #constrain! and #reject! are methods to reject any passing items. This method is the opposite, it will
          # reject any items that satisfy the predicate provided.
          def accept!(methods: [], name: nil, &block)
            constrain!(methods: methods, name: name, mode: :accept,  &block)
          end
        end
      end
    end
  end
end
