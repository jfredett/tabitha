require 'spec_helper'

RSpec.describe Tabitha::Model::Struct do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  describe "Standard Structs" do
    let(:standard_struct) {
      <<-CODE.strip
        struct Standard {
          pub field1: u32,
          field2: i32,
        }
      CODE
    }

    let(:expected) {
      Struct.new(
        :Standard,
        [],
        [ Field.new("pub", "field1", "u32"),
          Field.new("", "field2", "i32") ]
      )
    }

    it "parses a standard struct" do
      Tabitha::Model::Struct.parse!(standard_struct)
      expect { Tabitha::Model::Struct[:Standard] }.to eq expected
    end
  end

  describe "Structs With Generics" do
    let(:generic_struct) {
      <<-CODE.strip
        struct Generic<T> {
          pub field1: T,
          field2: i32,
        }
      CODE
    }

    let(:expected) {
      Tabitha::Model::Struct.new(
        :Generic,
        [ Generic::new("T") ],
        [ Field.new("pub", "field1", Generic[this, "T"]),
          Field.new("", "field2", "i32") ]
      )
    }

    it "parses a struct with generics" do
      Tabitha::Model::Struct.parse!(generic_struct)
      binding.pry
      expect { Tabitha::Model::Struct[:Generic] }.to eq expected
    end
  end

end
