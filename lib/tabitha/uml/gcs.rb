module Tabitha
module UML
  # Generic Constraint System, for printing out generics systems in various ways.
  class GCS
    class Constraint
      attr_reader: :type, :trait
    end



    attr_accessor :types, :facts

    def initialize
      @current_type = nil
      @types = {}
    end

    def add_type!(type)
      # TODO: Marshall this away from symbols, these should be refs to real types, or failing that, they can be
      # wrapped in some `VariableType` struct
      @types[type.to_sym] ||= Entry.new(self, :type, type)
      @current_type = @types[type.to_sym] if @current_type.nil?
    end

    def finish!
      @current_type = nil
    end

    def constrain!(trait)
      @current_type.constrain!(by: trait)
    end

    def [](type)
      @types[type.to_sym]
    end

    def add_fact!(type, fact)
      @facts << { type: type.to_sym, fact: fact }
    end

    def types
      @types.values
    end
    attr_reader :facts

    def to_s
      # goal, given a struct
      #
      # struct<T : Foo<U>, U>, the parse should result in:
      #
      # gcs = GCS.new
      #
      # gcs.add_type!(:T)
      # gcs[:T].constrain!(:Foo)
      # gcs.add_type!(:U)
      # gcs[:U].constrain!(:Foo)
      # gcs.add_type!(:U) # should no-op, since it's already there.
      # 
      # # Similarly, duplicate facts don't matter and will be reduced away.
      #
      # In the case of:
      #
      # struct<T : Foo<U>, U : Foo<V>, V>, the parse should result in:
      #
      # gcs.add_type!(:T)
      # gcs[:T].constrain!(:Foo)
      # gcs.add_type!(:U)
      # gcs[:U].constrain!(:Foo) # Here is an issue, we need to constrain _T_'s Foo.
      # gcs.add_type!(:U)        # Again, we see it twice, we add it twice
      # gcs[:U].constrain!(:Foo) # Here's the second constraint, but we have a fact already so this no-ops
      # gcs.add_type!(:V)        # This is fine
      # gcs[:V].constrain!(:Foo) # This is busted, now we have two contradictory constraints on `Foo`. 
      #
      # The existing model does capture the whole structure, but it's just a big PITA.
      #
      # I suppose if I treat this purely as a parse structure, I can add a parse state. I can crawl each generic as
      # a 'current' generic, then fill  things in from there. So the new parses would be:
      #
      #
      # struct<T : Foo<U>, U : Foo<V>, V>
      #
      # gcs = GCS.new do
      #   add_type!(:T)              # add :T, since no prioer type existed, it is the default current type.
      #   add_trait!(:Foo)           # add :Foo to the trait database
      #   constrain!(by: :Foo)       # Constrain :T by :Foo (implicitly)
      #   add_type!(:U)              # add :U, since :T is the current type, this _does not_ change the current type
      #   constrain!(:Foo, by: :U)   # Constrain :Foo's free parameter by :U, explicitly
      #   finish!                    # This is the end of the current generic, so we finish it, which clears the current type
      #   add_type!(:U)              # add :U, since the current type is nil, it gets set to :U
      #   add_trait!(:Foo)           # add :Foo to the trait database, it's already there but no worries.
      #   constrain!(by: :Foo)       # Constrain :U by :Foo (implicitly)
      #   add_type!(:V)              # add :V, since the current type is :U, no change
      #   constrain!(:Foo, by: :V)   # Constrain :Foo by :V (explicitly)
      #   finish!                    # End of the current generic, so we finish it.
      #   add_type!(:V)              # add :V, since the current type is nil, it gets set to :V
      #   finish!                    # End of the current generic, so we finish it.
      # end
      #
      # for `struct<T : Foo<Vec<U>>, U>`
      # for `struct<T : Foo<U, Vec<V>>, U, V>`
      # for `struct<T : Foo<U> + Bar<V>, U, V>`
      #
      # etc. some more esoteric examples
      # 
      # We can use the parse events to build up the structure we need to print the thing back out, and also emit
      # whatever other types into the database we need to.
      #
    end


    class Entry
      def initialize(parent, kind, name)
        @parent = parent
        @kind = kind
        @name = name.to_sym
      end

      def constrain!(t)
        t = t.to_sym

        case @kind
        when :type
          @parent.add_trait!(@name, t) unless @parent.has_key?(t)
        when @kind == :trait
          @parent.add_type!(@name, @parent[t]) unless @parent.has_key?(t)
        else
          raise "unexpected kind: #{@kind}"
        end

        @parent.add_fact!(@name, @name => @parent[t])
      end
    end
  end
end
