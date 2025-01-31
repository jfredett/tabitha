require 'spec_helper'

# TODO: Probably make these shared-examples-per describe, below.
RSpec.shared_examples "it captures the traits's definition" do |hash|
  subject(:trait) { Tabitha::Model::Trait[hash[:name]] }

  its(:name) { is_expected.to eq hash[:name] }

  describe :location do
    subject { trait.location }
    it { is_expected.to have_file }
    it { is_expected.to have_line }
    it { is_expected.to have_column }

    its(:file) { is_expected.to eq fixture('trait.rs') }
    its(:line) { is_expected.to eq hash[:location][:line] }
    its(:column) { is_expected.to eq hash[:location][:column] }
  end

  describe :trait_items do
    subject { trait.trait_items}
    let(:expected_trait_items) { hash[:trait_items] }

    it { is_expected.to eq expected_trait_items }
  end


  describe :associated_types do
    subject { trait.associated_types }
    let(:expected_associated_types) { hash[:associated_types] }

    it { is_expected.to eq expected_associated_types }
  end

  describe :generics do
    subject { trait.generics }
    let(:expected_generics) { hash[:generics] }

    it { is_expected.to eq expected_generics }
  end
end

RSpec.describe Tabitha::Model::Trait do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  before(:each) do
    Tabitha::Engine::SourceTree.clear!
    Tabitha::Model::Trait.clear!

    Tabitha::Engine::SourceTree::load!(fixture('trait.rs'))
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Trait)
  end


  it_behaves_like "it captures the traits's definition", {
    # // Trait with associated types
    # trait AssociatedType {
    #     type Item;
    #     fn get(&self) -> &Self::Item;
    # }
    name: :AssociatedType,
    location: { line: 1, column: 6 },
    trait_items: Set[
      Tabitha::Model::Fn::new(
        name: :get,
        visibility: :trait,
        modifier: nil,
        params: Set[
          Tabitha::Model::Fn::Param::new(
            name: :"&self",
            type: nil,
            location: trait_loc(0, 0)
          )
        ],
        return_type: :"&Self::Item",
        location: trait_loc(2,5)
      )
    ],
    associated_types: Set[
      Tabitha::Model::AssociatedType::new(
        name: :Item,
        default: nil,
        bounds: Set[],
        location: trait_loc(1, 6)
      )
    ],
    generics: Set[]
  }
end
