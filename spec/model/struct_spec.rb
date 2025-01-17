require 'spec_helper'

RSpec.describe Tabitha::Model::Struct do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  # TODO: struct from a file
  # TODO: struct with another struct as a field type

  describe "Standard" do
    before(:all) {
      standard_struct = <<-CODE.strip
      struct Standard {
        pub field1: u32,
        field2: i32,
      }
      CODE
      Tabitha::Model::Struct.parse!(standard_struct)
    }

    subject(:struct) { Tabitha::Model::Struct[:Standard] }


    its(:name) { is_expected.to eq :Standard }
    its(:visibility) { is_expected.to eq nil }
    its(:modifier) { is_expected.to eq nil }


    describe "its location" do
      subject { Tabitha::Model::Struct[:Standard].location }
      it { is_expected.to_not have_file }
      it { is_expected.to have_line }
      it { is_expected.to have_column }
    end

    describe "its fields" do
      def loc(line, col)
        Tabitha::Engine::Location.new(line: line, column: col)
      end

      subject { struct.fields }
      let(:field1) { Tabitha::Model::Field.new(vis: "pub", name: "field1", type: "u32", location: loc(1,12), parent: struct ) }
      let(:field2) { Tabitha::Model::Field.new(name: "field2", type: "i32", location: loc(2,8), parent: struct ) }
      let(:expected_fields) { [ field1, field2 ] }

      it { is_expected.to eq expected_fields }
      its(:first) { is_expected.to eq field1 }
      its(:last) { is_expected.to eq field2 }

      describe "field1" do
        subject { field1 }

        its(:vis) { is_expected.to eq "pub" }
        its(:name) { is_expected.to eq "field1" }
        its(:type) { is_expected.to eq "u32" }
      end

      describe "field2" do
        subject { field2 }

        its(:vis) { is_expected.to be_nil }
        its(:name) { is_expected.to eq "field2" }
        its(:type) { is_expected.to eq "i32" }
      end
    end
  end

  # describe "Structs With Generics" do
  #   let(:generic_struct) {
  #     <<-CODE.strip
  #     struct Generic<T> {
  #     pub field1: T,
  #     field2: i32,
  #     }
  #     CODE
  #   }

  #   let(:expected) {
  #     Tabitha::Model::Struct.new(
  #       :Generic,
  #       [ Generic::new("T") ],
  #       [ Model::Field.new("pub", "field1", Generic[this, "T"]),
  #         Model::Field.new("", "field2", "i32") ]
  #     )
  #   }

  #   it "parses a struct with generics" do
  #     Tabitha::Model::Struct.parse!(generic_struct)
  #     expect { Tabitha::Model::Struct[:Generic] }.to eq expected
  #   end
  # end

end
