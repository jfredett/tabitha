require 'spec_helper'

RSpec.describe Tabitha::Model::Struct do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  describe "Multiple Structs in one parse" do
    before(:all) do
      Tabitha::Model::Struct.parse!(nil, <<-CODE.strip)
      struct Foo {
        pub field1: u32,
      };

      struct Bar {
        field2: i32,
      };
      CODE
    end

    let (:foo) { Tabitha::Model::Struct[:Foo] }
    let (:bar) { Tabitha::Model::Struct[:Bar] }

    it "has parsed the Foo structure" do
      expect(foo.name).to eq :Foo
    end

    it "has parsed the Bar structure" do
      expect(bar.name).to eq :Bar
    end
  end

  describe "Zero Sized Types" do
    before(:all) do
      Tabitha::Model::Struct.parse!(nil, <<-CODE.strip)
      struct ZST;
      CODE
    end

    subject(:struct) { Tabitha::Model::Struct[:ZST] }

    its(:name) { is_expected.to eq :ZST }
    its(:visibility) { is_expected.to eq nil }
    its(:modifier) { is_expected.to eq nil }
    its(:fields) { is_expected.to be_empty }
    its(:generics) { is_expected.to eq nil }
    its(:location) { is_expected.to_not have_file }
    its(:location) { is_expected.to have_line }
    its(:location) { is_expected.to have_column }
    its(:"location.line") { is_expected.to eq 0 }
    its(:"location.column") { is_expected.to eq 7 }

  end

  describe "Struct with Field that is a Struct" do
    before(:all) do
      Tabitha::Model::Struct.parse!(nil, <<-CODE.strip)
      struct Inner;

      struct StructWithStruct {
        pub field1: Inner,
      }
      CODE
    end

    subject(:struct) { Tabitha::Model::Struct[:StructWithStruct] }
    let(:inner) { Tabitha::Model::Struct[:Inner] }

  its(:"fields.first.type") { is_expected.to eq inner }
  end



  describe "FromFile" do
    before(:all) {
      Tabitha::Engine::SourceTree::load!(fixture('struct.rs'))
      Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Struct)
    }
    subject(:struct) { Tabitha::Model::Struct[:FromFile] }

    its(:name) { is_expected.to eq :FromFile }
    its(:visibility) { is_expected.to eq nil }
    its(:modifier) { is_expected.to eq nil }

    describe "#location" do
      subject { struct.location }

      it { is_expected.to have_file }
      it { is_expected.to have_line }
      it { is_expected.to have_column }
      
      its(:file) { is_expected.to eq fixture('struct.rs') }
      its(:line) { is_expected.to eq 0 }
      its(:column) { is_expected.to eq 7 }
    end

    describe "#fields" do
      subject(:field) { struct.fields[0] }

      let(:field1) { Tabitha::Model::Field.new(vis: "pub", name: "dummyField", type: "()", location: Location::new(file: fixture('struct.rs'), line: 1, column: 8), parent: struct ) }

      its(:vis) { is_expected.to eq "pub" }
      its(:name) { is_expected.to eq "dummyField" }
      its(:type) { is_expected.to eq :"()" }

      describe "#location" do
        subject { field.location }

        it { is_expected.to have_file }
        it { is_expected.to have_line }
        it { is_expected.to have_column }

        its(:file) { is_expected.to eq fixture('struct.rs') }
        its(:line) { is_expected.to eq 1 }
        its(:column) { is_expected.to eq 8 }
      end


    end


  end

  describe "Standard" do
    before(:all) {
      Tabitha::Model::Struct.parse!(nil, <<-CODE.strip)
      struct Standard {
        pub field1: u32,
        field2: i32,
      }
      CODE
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

      subject { struct.fields }
      let(:field1) { Tabitha::Model::Field.new(vis: "pub", name: "field1", type: :u32, location: loc(1,12), parent: struct ) }
      let(:field2) { Tabitha::Model::Field.new(name: "field2", type: :i32, location: loc(2,8), parent: struct ) }
      let(:expected_fields) { [ field1, field2 ] }

      it { is_expected.to eq expected_fields }
    end
  end

  # TODO: struct with multiple generics
  # TODO: struct with constrained generics
  # TODO: struct with multiple, independently constrained generics
  describe "Structs With Generics" do
    before(:all) {
      Tabitha::Model::Struct.parse!(nil, <<-CODE.strip)
      struct Generic<T> {
        pub field1: T,
        field2: i32,
      }
      CODE
    }
    subject(:struct) { Tabitha::Model::Struct[:Generic] }

    its(:name) { is_expected.to eq :Generic }
    its(:visibility) { is_expected.to eq nil }
    its(:modifier) { is_expected.to eq nil }
    # TODO: I'm pretty sure this is the wrong way to handle params for this longterm, but it works for now, I should
    # evenetually store the whole node and not just the text
    its(:generics) { is_expected.to eq "<T>" }

    describe "its location" do
      subject { Tabitha::Model::Struct[:Generic].location }

      it { is_expected.to_not have_file }
      it { is_expected.to have_line }
      it { is_expected.to have_column }

      its(:line) { is_expected.to eq 0 }
      its(:column) { is_expected.to eq 7 }
    end

    describe "its fields" do
      subject { struct.fields }

      let(:field1) { Tabitha::Model::Field.new(vis: "pub", name: "field1", type: :T, location: loc(1,12), parent: struct ) }
      let(:field2) { Tabitha::Model::Field.new(name: "field2", type: :i32, location: loc(2,8), parent: struct ) }

      let(:expected_fields) { [ field1, field2 ] }

      it { is_expected.to eq expected_fields }
    end
  end
end
