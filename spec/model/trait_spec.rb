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

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait with default methods
  #   name: :WithDefaultMethods,
  #   location: { line: 8, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :greet,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         )
  #       ],
  #       return_type: nil,
  #       location: trait_loc(9,5)
  #     )
  #   ],
  #   associated_types: Set[],
  #   generics: Set[]
  # }

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait with generic methods
  #   name: :GenericTrait,
  #   location: { line: 14, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :add,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :other,
  #           type: :T,
  #           location: trait_loc(1, 6)
  #         )
  #       ],
  #       return_type: :T,
  #       location: trait_loc(15,5)
  #     )
  #   ],
  #   associated_types: Set[],
  #   generics: Set[:T]
  # }

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait with lifetime bounds
  #   name: :LifetimeBounded,
  #   location: { line: 20, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :read,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         )
  #       ],
  #       return_type: :"&'a str",
  #       location: trait_loc(21,5)
  #     )
  #   ],
  #   associated_types: Set[],
  #   generics: Set[:"'a"]
  # }

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait with multiple trait bounds
  #   name: :TraitWithMultipleBounds,
  #   location: { line: 24, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :subtract,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :other,
  #           type: :T,
  #           location: trait_loc(1, 6)
  #         )
  #       ],
  #       return_type: :T,
  #       location: trait_loc(26,5)
  #     )
  #   ],
  #   associated_types: Set[],
  #   generics: Set[:T]
  # }

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait with bounded associated type
  #   name: :ComplexTrait,
  #   location: { line: 30, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :get,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         )
  #       ],
  #       return_type: :"&Self::Item",
  #       location: trait_loc(32,5)
  #     )
  #   ],
  #   associated_types: Set[
  #     Tabitha::Model::AssociatedType::new(
  #       name: :Item,
  #       default: nil,
  #       bounds: Set[:Clone, :Debug],
  #       location: trait_loc(31, 6)
  #     )
  #   ],
  #   generics: Set[]
  # }

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait with default methods and multiple generics
  #   name: :MultiGenericDefault,
  #   location: { line: 35, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :greet,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :value1,
  #           type: :T,
  #           location: trait_loc(1, 6)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :value2,
  #           type: :U,
  #           location: trait_loc(2, 6)
  #         )
  #       ],
  #       return_type: nil,
  #       location: trait_loc(37,5)
  #     )
  #   ],
  #   associated_types: Set[],
  #   generics: Set[:T, :U]
  # }

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait with generic methods, lifetime bounds, and where clause
  #   name: :GenericWithLifetime,
  #   location: { line: 42, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :add,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :other,
  #           type: :"&'a T",
  #           location: trait_loc(1, 6)
  #         )
  #       ],
  #       return_type: :T,
  #       location: trait_loc(47,5)
  #     )
  #   ],
  #   associated_types: Set[],
  #   generics: Set[:"'a", :T]
  # }

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait with multiple trait items
  #   name: :FullTrait,
  #   location: { line: 50, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :multiply,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :value1,
  #           type: :T,
  #           location: trait_loc(1, 6)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :value2,
  #           type: :U,
  #           location: trait_loc(2, 6)
  #         )
  #       ],
  #       return_type: :"Self::Item",
  #       location: trait_loc(54,5)
  #     ),
  #     Tabitha::Model::Fn::new(
  #       name: :subtract,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :value1,
  #           type: :T,
  #           location: trait_loc(1, 6)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :value2,
  #           type: :U,
  #           location: trait_loc(2, 6)
  #         )
  #       ],
  #       return_type: :"Self::Item",
  #       location: trait_loc(55,5)
  #     )
  #   ],
  #   associated_types: Set[
  #     Tabitha::Model::AssociatedType::new(
  #       name: :Item,
  #       default: nil,
  #       bounds: Set[:Debug],
  #       location: trait_loc(52, 6)
  #     )
  #   ],
  #   generics: Set[:T, :U]
  # }

  # it_behaves_like "it captures the traits's definition", {
  #   # // Trait combining all features
  #   name: :MegaTrait,
  #   location: { line: 58, column: 6 },
  #   trait_items: Set[
  #     Tabitha::Model::Fn::new(
  #       name: :get,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         )
  #       ],
  #       return_type: :"&Self::Item",
  #       location: trait_loc(66,5)
  #     ),
  #     Tabitha::Model::Fn::new(
  #       name: :multiply,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :value1,
  #           type: :T,
  #           location: trait_loc(1, 6)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :value2,
  #           type: :U,
  #           location: trait_loc(2, 6)
  #         )
  #       ],
  #       return_type: :"Self::Item",
  #       location: trait_loc(67,5)
  #     ),
  #     Tabitha::Model::Fn::new(
  #       name: :subtract,
  #       visibility: :trait,
  #       modifier: nil,
  #       params: Set[
  #         Tabitha::Model::Fn::Param::new(
  #           name: :"&self",
  #           type: nil,
  #           location: trait_loc(0, 0)
  #         ),
  #         Tabitha::Model::Fn::Param::new(
  #           name: :other,
  #           type: :"&'static str",
  #           location: trait_loc(1, 6)
  #         )
  #       ],
  #       return_type: :"&'static str",
  #       location: trait_loc(68,5)
  #     )
  #   ],
  #   associated_types: Set[
  #     Tabitha::Model::AssociatedType::new(
  #       name: :Item,
  #       default: nil,
  #       bounds: Set[:Debug],
  #       location: trait_loc(64, 6)
  #     )
  #   ],
  #   generics: Set[:T, :U]
  # }
end
