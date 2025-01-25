require 'spec_helper'

RSpec.describe Tabitha::Model::Struct do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  # TODO: Reorganize these and factor out a bunch of the redundant test code into shared examples if possible
  # TODO: Move these structs to fixtures? Maybe just one big one?
  #

  before(:each) do
    Tabitha::Engine::SourceTree.clear!
    Tabitha::Model::Struct.clear!

    Tabitha::Engine::SourceTree::load!(fixture('scratch.rs'))
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Struct)
  end

  describe "Zero Sized Types" do
    subject(:struct) { Tabitha::Model::Struct[:ZST] }

    its(:name) { is_expected.to eq :ZST }
    its(:visibility) { is_expected.to be_nil }
    its(:fields) { is_expected.to be_empty }
    its(:generics) { is_expected.to be_empty }
  end

  describe "Struct with Field that is a Struct" do
    subject(:struct) { Tabitha::Model::Struct[:StructWithStruct] }
    let(:inner) { Tabitha::Model::Struct[:Inner] }

    its(:"fields.keys.length") { is_expected.to be 1 }
    describe "the field" do
      subject { struct.fields[:field1] }
      its(:type) { is_expected.to eq :Inner }
    end
  end

  describe "Standard" do
    subject(:struct) { Tabitha::Model::Struct[:Standard] }

    its(:name) { is_expected.to eq :Standard }
    its(:visibility) { is_expected.to be_nil }
    its(:generics) { is_expected.to be_empty }
    its(:fields) { are_expected.to_not be_empty }

    describe :location do
      subject { struct.location }
      it { is_expected.to have_file }

      its(:file) { is_expected.to eq fixture('scratch.rs') }
      its(:line) { is_expected.to eq 16 }
      its(:column) { is_expected.to eq 7 }
    end

    describe "its fields" do
      subject { struct.fields }
      let(:field1) { Tabitha::Model::Field.new(visibility: "pub", name: "field1", type: :u32, location: scratch_loc(17,8), parent: struct ) }
      let(:field2) { Tabitha::Model::Field.new(name: "field2", type: :i32, location: scratch_loc(18,4), parent: struct ) }
      let(:expected_fields) { { field1: field1, field2: field2 } }

      it { is_expected.to eq expected_fields }
    end
  end

  describe "Structs With Generics" do
    before(:all) {
      Tabitha::Model::Struct.parse!(nil, <<-CODE.strip)
      struct GenericStruct<T> {
      pub field1: T,
      field2: i32,
      }
      CODE
    }
    subject(:struct) { Tabitha::Model::Struct[:GenericStruct] }

    its(:name) { is_expected.to eq :GenericStruct }
    its(:visibility) { is_expected.to eq nil }

    let(:expected_generics) { { T: Tabitha::Model::Generic.new(name: :T, constraints: {}, location: scratch_loc(24,7), parent: struct) } }

    its(:generics) { is_expected.to eq expected_generics }

    describe "its location" do
      subject { struct.location }

      it { is_expected.to have_file }
      it { is_expected.to have_line }
      it { is_expected.to have_column }

      its(:file) { is_expected.to eq fixture('scratch.rs') }
      its(:line) { is_expected.to eq 24 }
      its(:column) { is_expected.to eq 7 }
    end

    describe "its fields" do
      subject { struct.fields }

      let(:field1) { Tabitha::Model::Field.new(visibility: "pub", name: "field1", type: :T, location: scratch_loc(25, 8), parent: struct ) }
      let(:field2) { Tabitha::Model::Field.new(name: "field2", type: :i32, location: scratch_loc(26,4), parent: struct ) }

      let(:expected_fields) { { field1: field1, field2: field2 } }

      it { is_expected.to eq expected_fields }
    end
  end

  describe "Structs With Multiple Generics" do
    subject(:struct) { Tabitha::Model::Struct[:MultipleGeneric] }

    its(:name) { is_expected.to eq :MultipleGeneric }
    its(:visibility) { is_expected.to eq nil }
    let(:expected_generics) { {
      T: Tabitha::Model::Generic.new(name: :T, constraints: {}, location: scratch_loc(29,7), parent: struct),
      U: Tabitha::Model::Generic.new(name: :U, constraints: {}, location: scratch_loc(29,7), parent: struct)
    } }

    its(:generics) { are_expected.to eq expected_generics }
  end



  describe "Constrained Where Generic" do
    subject(:struct) { Tabitha::Model::Struct[:ConstrainedWhereGeneric] }

    it { is_expected.to_not be_nil }

    # This is the object we ultimately want to see in both the where clause and the generic constraint list
    let(:expected_constraint_t) {
      # NOTE: I think Constraint might actually just be 'Trait' here, I probably don't need to do any of the type
      # resolution, maybe I just punt here?
      Tabitha::Model::Constraint::new(
        bound: :Copy,
        parent: struct.generics[:T],
        location: scratch_loc(34, 43)
      )
    }
    let(:expected_generics) { {
      T: Tabitha::Model::Generic::new(name: :T, constraints: { Copy: expected_constraint_t }, location: scratch_loc(34,7), parent: struct),
    } }

    its(:generics) { is_expected.to eq expected_generics }
  end

  describe "Constrained Generic" do
    subject(:struct) { Tabitha::Model::Struct[:ConstrainedGeneric] }
    # This is the object we ultimately want to see in both the where clause and the generic constraint list
    let(:expected_constraint) {
      Tabitha::Model::Constraint.new(
        bound: Tabitha::Model::Type.marshall_type(:Copy),
        parent: struct.generics[:T],
        location: scratch_loc(38, 30)
      )
    }

    let(:expected_generic) { { T: Tabitha::Model::Generic.new(name: :T, constraints: { Copy: expected_constraint }, location: scratch_loc(38,7), parent: struct) } }

    it { is_expected.to_not be_nil }
    its(:generics) { is_expected.to eq expected_generic }
  end

  describe "Multiple Constrained Generic" do
    subject(:struct) { Tabitha::Model::Struct[:MultipleConstrainedGeneric] }

    let(:expected_constraint_t) {
      Tabitha::Model::Constraint::new(
        bound: Tabitha::Model::Type.marshall_type(:Copy),
        location: scratch_loc(42,38),
        parent: struct.generics[:T],
      )
    }

    let(:expected_constraint_u) {
      Tabitha::Model::Constraint::new(
        bound: Tabitha::Model::Type.marshall_type(:Clone),
        location: scratch_loc(42, 48),
        parent: struct.generics[:U],
      )
    }

    let(:expected_generics) { {
      T: Tabitha::Model::Generic::new(name: :T, constraints: { Copy: expected_constraint_t }, location: scratch_loc(42,7), parent: struct),
      U: Tabitha::Model::Generic::new(name: :U, constraints: { Clone: expected_constraint_u }, location: scratch_loc(42,7), parent: struct)
    } }


    its(:generics) { is_expected.to eq expected_generics }
  end

  describe "Multiple Constrained Where Generic" do
    subject(:struct) { Tabitha::Model::Struct[:MultipleConstrainedWhereGeneric] }

    let(:expected_constraint_t) {
      Tabitha::Model::Constraint::new(
        bound: Tabitha::Model::Type.marshall_type(:Copy),
        location: scratch_loc(9, 7),
        parent: struct.generics[:T],
      )
    }

    let(:expected_constraint_u) {
      Tabitha::Model::Constraint::new(
        bound: Tabitha::Model::Type.marshall_type(:Clone),
        location: scratch_loc(10, 7),
        parent: struct.generics[:U],
      )
    }

    let(:expected_generics) { {
      T: Tabitha::Model::Generic::new(name: :T, constraints: { Copy: expected_constraint_t }, location: scratch_loc(8, 7), parent: struct),
      U: Tabitha::Model::Generic::new(name: :U, constraints: { Clone: expected_constraint_u }, location: scratch_loc(8, 7), parent: struct)
    } }

    its(:generics) { is_expected.to eq expected_generics }

    context do
      subject { struct.generics[:T] }
      its(:constraints) { is_expected.to eq({ Copy: expected_constraint_t }) }
    end

  end

  # TODO: Nested Constraint and Nested Where Constraint
  # describe "Nested Constraint" do
  #   subject(:struct) { Tabitha::Model::Struct[:NestedConstraint] }

  #   let(:expected_constraint_t) {
  #     Tabitha::Model::Constraint::new(
  #       name: :T,
  #       bound: :Foo,
  #       # BUG: This may reveal an issue, the nesting there marshall's a generic parameter, which is not ideal. I
  #       # really want to have type marshalling be local->global, i.e., to start looking for the closest available
  #       # type. I suppose for now I intend to treat these primarily as text to render into graphs, so not a big issue.
  #       generics: [ :U ],
  #       location: scratch_loc(4,28),
  #       parent: struct,
  #     )
  #   }

  #   let(:expected_generics) { {
  #     T: Tabitha::Model::Generic::new(name: :T, constraints: { T: expected_constraint_t }, location: scratch_loc(4,7), parent: struct),
  #     U: Tabitha::Model::Generic::new(name: :U, constraints: {}, location: scratch_loc(4,7), parent: struct)
  #   } }

  #   its(:generics) { binding.pry ; is_expected.to eq expected_generics }
  # end
end
