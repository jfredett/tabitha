require 'spec_helper'

# TODO: Probably make these shared-examples-per describe, below.
RSpec.shared_examples "it captures the enum's definition" do |hash|
  subject(:enum) { Tabitha::Model::Enum[hash[:name]] }

  its(:name) { is_expected.to eq hash[:name] }

  its(:visibility) { is_expected.to eq hash[:visibility] }

  describe :location do
    subject { enum.location }
    it { is_expected.to have_file }
    it { is_expected.to have_line }
    it { is_expected.to have_column }

    # TODO: This should maybe refer to something in the hash as well?
    its(:file) { is_expected.to eq fixture('enum.rs') }
    its(:line) { is_expected.to eq hash[:location][:line] }
    its(:column) { is_expected.to eq hash[:location][:column] }
  end

  describe :variants do
    subject { enum.variants }
    let(:expected_variants) { hash[:variants] }

    it { is_expected.to eq expected_variants }
  end

  describe :generics do
    subject { enum.generics }
    let(:expected_generics) { hash[:generics] }

    it { is_expected.to eq expected_generics }
  end
end

RSpec.describe Tabitha::Model::Enum do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  before(:each) do
    Tabitha::Engine::SourceTree.clear!
    Tabitha::Model::Enum.clear!

    Tabitha::Engine::SourceTree::load!(fixture('enum.rs'))
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Enum)
  end

  it_behaves_like "it captures the enum's definition", {
    name: :WeirdEmptyEnum,
    visibility: :pub,
    location: { line: 20, column: 9 },
    variants: Set.new,
    generics: Set.new
  }

  it_behaves_like "it captures the enum's definition", {
    name: :Simple,
    visibility: nil,
    location: { line: 0, column: 5 },
    variants: Set[
      Tabitha::Model::Enum::Variant::new(
        name: :VariantA,
        fields: Set.new,
        location: enum_loc(1, 4),
      ),
      Tabitha::Model::Enum::Variant::new(
        name: :VariantB,
        fields: Set.new,
        location: enum_loc(2, 4),
      )
    ],
    generics: Set.new
  }

  it_behaves_like "it captures the enum's definition", {
    name: :WithVariantArg,
    visibility: nil,
    location: { line: 5, column: 5 },
    variants: Set[
      Tabitha::Model::Enum::Variant::new(
        name: :VariantArgA,
        fields: Set[
          Tabitha::Model::Field::new(
            name: :"0",
            type: :isize,
            location: enum_loc(6, 16),
          ),
        ],
        location: enum_loc(6, 4),
      ),
      Tabitha::Model::Enum::Variant::new(
        name: :VariantArgB,
        fields: Set[
          Tabitha::Model::Field::new(
            name: :"0",
            type: :usize,
            location: enum_loc(7, 16),
          ),
          Tabitha::Model::Field::new(
            name: :"1",
            type: :bool,
            location: enum_loc(7, 23),
          ),
        ],
        location: enum_loc(7, 4),
      ),
      Tabitha::Model::Enum::Variant::new(
        name: :VariantNoArg,
        fields: Set.new,
        location: enum_loc(8, 4),
      ),
    ],
    generics: Set.new
  }

  it_behaves_like "it captures the enum's definition", {
    name: :WithNamedArgs,
    visibility: :pub,
    location: { line: 11, column: 9 },
    variants: Set[
      Tabitha::Model::Enum::Variant::new(
        name: :VariantArgA,
        fields: Set[
          Tabitha::Model::Field::new(
            name: :field1,
            type: :isize,
            location: enum_loc(12, 18),
          ),
        ],
        location: enum_loc(12, 4),
      ),
      Tabitha::Model::Enum::Variant::new(
        name: :VariantArgB,
        fields: Set[
          Tabitha::Model::Field::new(
            name: :field1,
            type: :usize,
            location: enum_loc(13, 18),
          ),
          Tabitha::Model::Field::new(
            name: :field2,
            type: :bool,
            location: enum_loc(13, 33),
          ),
        ],
        location: enum_loc(13, 4),
      )
    ],
    generics: Set.new
  }

  it_behaves_like "it captures the enum's definition", {
    name: :GenericEnum,
    visibility: nil,
    location: { line: 24, column: 5 },
    variants: Set[
      Tabitha::Model::Enum::Variant::new(
        name: :Variant,
        fields: Set[
          Tabitha::Model::Field::new(
            name: :"0",
            type: :T,
            location: enum_loc(25, 12),
          ),
        ],
        location: enum_loc(25, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        bounds: Set.new,
        location: enum_loc(24, 17),
      )
    ]
  }

  it_behaves_like "it captures the enum's definition", {
    name: :GenericBoundedEnum,
    visibility: :pub,
    location: { line: 28, column: 9 },
    variants: Set[
      Tabitha::Model::Enum::Variant::new(
        name: :Variant,
        fields: Set[
          Tabitha::Model::Field::new(
            name: :"0",
            type: :T,
            location: enum_loc(29, 12),
          ),
        ],
        location: enum_loc(29, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        bounds: Set[
          Tabitha::Model::Bound::new(
            bound: :Copy,
            location: enum_loc(28, 32),
          ),
        ],
        location: enum_loc(28, 28),
      )
    ]
  }

  it_behaves_like "it captures the enum's definition", {
    name: :GenericWhereBoundedEnum,
    visibility: :pub,
    location: { line: 32, column: 9 },
    variants: Set[
      Tabitha::Model::Enum::Variant::new(
        name: :Variant,
        fields: Set[
          Tabitha::Model::Field::new(
            name: :"0",
            type: :T,
            location: enum_loc(33, 12),
          ),
        ],
        location: enum_loc(33, 4),
      ),
      Tabitha::Model::Enum::Variant::new(
        name: :None,
        fields: Set.new,
        location: enum_loc(34, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        bounds: Set[
          Tabitha::Model::Bound::new(
            bound: :Copy,
            location: enum_loc(32, 46),
          ),
        ],
        location: enum_loc(32, 42),
      )
    ]
  }

  it_behaves_like "it captures the enum's definition", {
    name: :GenericBoundedEnumWithNamedField,
    visibility: :pub,
    location: { line: 37, column: 9 },
    variants: Set[
      Tabitha::Model::Enum::Variant::new(
        name: :Variant,
        fields: Set[
          Tabitha::Model::Field::new(
            name: :field1,
            type: :T,
            location: enum_loc(38, 14),
          ),
        ],
        location: enum_loc(38, 4),
      ),
      Tabitha::Model::Enum::Variant::new(
        name: :None,
        fields: Set.new,
        location: enum_loc(39, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        bounds: Set[
          Tabitha::Model::Bound::new(
            bound: :Copy,
            location: enum_loc(37, 46),
          ),
        ],
        location: enum_loc(37, 42),
      )
    ]
  }
end

