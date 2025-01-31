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
    #       # self will be the actual thetical class, so you can just do internal iteration. Again, you're responsible
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

        def method_missing(name, *args, &block)
          return if @set.nil?
          return unless @set.respond_to?(name)

          @set.send(name, *args, &block).tap do
            # TODO: This is probably an `any?` call?
            # TODO: Combine to a single pass
            self.class.hooks[:"__global__"].each do |hook|
              raise "Constraint failed." if hook.(@set)
            end

            self.class.hooks[name].each do |hook|
              raise "Constraint failed." if hook.(@set)
            end
          end
        end

        class << self
          def hooks
            @hooks ||= Hash.new { |h, k| h[k] = [] }
            @hooks
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
          def constrain!(*args, &block)
            thunk = case block.arity
            when 0
              ->(set) { set.instance_exec(&block) }
            when 1
              ->(set) { set.all? { |item| self.instance_exec(item, &block) } }
            when 2
              ->(set) { set.all? { |left| set.all? { |right| self.instance_exec(left, right, &block) if left != right } } }
            else
              raise "Invalid arity (#{block.arity}) for constraint block."
            end

            if args.empty?
              self.hooks[:"__global__"] << thunk
            else
              args.each { |arg| self.hooks[arg] << thunk }
            end
          end

          alias reject! constrain!

          # #constrain! and #reject! are methods to reject any passing items. This method is the opposite, it will
          # reject any items that satisfy the predicate provided.
          def accept!(*args, &block)
            new_block = ->(*args) { not block.(*args) }
            # HACK: This is nearly sin, but not quite.
            #
            # I need to invert the logic of a reject hook, the easiest way to do that is to slap a `not` in front of the
            # otherwise normal block. This, however, forces an arity count of -1, since the `*args` arity is `-1`, even
            # though I'm not doing anything to change the arity of the block itself. Thus, I simply tell Ruby that, in
            # fact, the arity of the new block is the same as the old... by blowing away it's implementation of the
            # arity method entirely and replacing it with the arity of the original block.
            new_block.define_singleton_method(:arity) { block.arity }
            constrain!(*args, &new_block)
          end
        end
      end
    end
  end
end
