require 'spec_helper'

RSpec.describe Tabitha::Model::Generic do

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

  describe "Standard" do
    subject { Tabitha::Model::Struct[:Standard] }

    its(:generic_span) { is_expected.to be_nil }
    it { expect(subject.generic_span(with_constraints: true)).to be_nil }
  end

  describe "GenericStruct" do
    subject { Tabitha::Model::Struct[:GenericStruct] }

    its(:generic_span) { is_expected.to eq "T" }
    it { expect(subject.generic_span(with_constraints: true)).to eq "T" }
  end

  describe "MultipleGeneric" do
    subject { Tabitha::Model::Struct[:MultipleGeneric] }

    its(:generic_span) { is_expected.to eq "T, U" }
    it { expect(subject.generic_span(with_constraints: true)).to eq "T, U" }
  end

  describe "ConstrainedGeneric" do
    subject { Tabitha::Model::Struct[:ConstrainedGeneric] }

    its(:generic_span) { is_expected.to eq "T" }
    it { expect(subject.generic_span(with_constraints: true)).to eq "T : Copy" }
  end

  describe "MultipleConstrainedGeneric" do
    subject { Tabitha::Model::Struct[:MultipleConstrainedGeneric] }

    its(:generic_span) { is_expected.to eq "T, U" }
    it { expect(subject.generic_span(with_constraints: true)).to eq "T : Copy, U : Clone" }
  end

  describe "MultiplyConstrainedSingleGeneric" do
    subject { Tabitha::Model::Struct[:MultiplyConstrainedSingleGeneric] }

    its(:generic_span) { is_expected.to eq "T" }
    it { expect(subject.generic_span(with_constraints: true)).to eq "T : Copy + Clone" }
  end

  describe "ZST" do
    subject { Tabitha::Model::Struct[:ZST] }

    its(:generic_span) { is_expected.to be_nil }
    it { expect(subject.generic_span(with_constraints: true)).to be_nil }
  end

  describe "NestedConstraint" do
    subject { Tabitha::Model::Struct[:NestedConstraint] }

    its(:generic_span) { is_expected.to eq "T, U" }
    it { expect(subject.generic_span(with_constraints: true)).to eq "T : Foo<U>, U" }
  end

  describe "WeirdEmpty" do
    subject { Tabitha::Model::Struct[:WeirdEmpty] }

    its(:generic_span) { is_expected.to be_nil }
    it { expect(subject.generic_span(with_constraints: true)).to be_nil }
  end


  # describe "MultipleConstrainedWhereGeneric"


  # describe "an unconstrainted generic type" do
  #   subject { described_class.new(name: :T) }

  #   its(:name) { is_expected.to eq(:T) }
  #   its(:as_span) { is_expected.to eq("T") }
  # end

  # describe "an constrainted generic type" do
  #   let(:constraint) { Tabitha::Model::Constraint.new(name: :T, trait: :Cons) }

  #   subject { described_class.new(name: :T,  constraints: {Cons: constraint}) }

  #   it { is_expected.to be_constrained }
  #   its(:as_span) { is_expected.to eq("T") }
  #   it "renders the constraints if you ask" do
  #     expect(subject.as_span(with_constraints: true)).to eq("T : Cons")
  #   end
  # end

  # describe "a multiply constrainted generic type" do
  #   let(:constraint_1) { Tabitha::Model::Constraint.new(name: :T, trait: :Cons1) }
  #   let(:constraint_2) { Tabitha::Model::Constraint.new(name: :T, trait: :Cons2) }

  #   let(:generic) { described_class.new(name: :T,  constraints: {Cons1: constraint_1, Cons2: constraint_2 }) }

  #   context "the generic object itself" do
  #     subject { generic }

  #     its(:as_span) { is_expected.to eq("T") }
  #   end

  #   context "in a struct" do
  #     subject(:struct) { Tabitha::Model::Struct::new(name: :S, generics: { T: generic }) }

  #     its(:generic_span) { is_expected.to eq("T") }
  #     it "renders the constraints if you ask" do
  #       expect(subject.generic_span(with_constraints: true)).to eq("T : Cons1 + Cons2")
  #     end
  #   end
  # end

  # # TODO: these really talk about the _type_, so I need to test against a struct rather than just testing the generic
  # # directly.

  # describe "a generically constrained generic type" do
  #   let(:inner_generic) { Tabitha::Model::Generic::new(name: :U, constraints: {}) }
  #   let(:generic_constraint) { Tabitha::Model::Constraint.new(name: :T, trait: :GenericConstraint, generics: {U: inner_generic }) }

  #   let(:generic) { described_class.new(name: :T,  constraints: {GenericConstraint: generic_constraint}) }
  #   context "on it's own" do
  #     subject { generic }

  #     its(:as_span) { is_expected.to eq("T") }
  #     it "renders the constraints if you ask" do
  #       binding.pry
  #       expect(subject.as_span(with_constraints: true)).to eq("T : GenericConstraint<U>")
  #     end
  #   end


  #   context "used in a struct" do
  #     subject(:struct) { Tabitha::Model::Struct::new(name: :S, generics: { T: generic }) }

  #     its(:generic_span) { is_expected.to eq("T, U") }
  #     it "renders the constraints if you ask" do
  #       expect(subject.generic_span(with_constraints: true)).to eq("T : GenericConstraint<U>, U")
  #     end
  #   end
  # end

  # describe "a generically constrained generic type where the generic constraint is also constrained" do
  #   let(:generic_constraint) { Tabitha::Model::Constraint.new(name: :T, trait: :GenericConstraint, generics: {U: inner_generic }) }
  #   let(:inner_constraint) { Tabitha::Model::Constraint::new(name: :U, trait: :InnerConstraint) }
  #   let(:inner_generic) { described_class::new(name: :U, constraints: { InnerConstraint: inner_constraint }) }
  #   let(:outer_generic) { described_class::new(name: :T, constraints: { GenericConstraint: generic_constraint, InnerConstraint: inner_constraint}) }

  #   # This is a struct because I want to test how the whole span gets rendered,
  #   subject(:struct) { Tabitha::Model::Struct::new(name: :S, generics: { T: generic_constraint , U: inner_constraint }) }

  #   its(:generic_span) { is_expected.to eq("T, U") }
  #   it "renders the constraints if you ask" do
  #     expect(subject.generic_span(with_constraints: true)).to eq("T : GenericConstraint<U>, U : InnerConstraint")
  #   end
  # end

  # describe "a concretely constrained generic type" do
  #   let(:generic_constraint) { Tabitha::Model::Constraint.new(name: :T, trait: :GenericConstraint, generics: { U: :i32 }) }

  #   subject { described_class.new(name: :T,  constraints: { GenericConstraint: generic_constraint }) }

  #   it { is_expected.to be_constrained }
  #   its(:as_span) { is_expected.to eq("T") }
  #   it "renders the constraints if you ask" do
  #     expect(subject.as_span(with_constraints: true)).to eq("T : GenericConstraint<i32>")
  #   end
  # end
end
