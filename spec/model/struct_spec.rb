require 'spec_helper'

# TODO: Probably make these shared-examples-per describe, below.
RSpec.shared_examples "it captures the struct's definition" do |hash|
  subject(:struct) { Tabitha::Model::Struct[hash[:name]] }

  its(:name) { is_expected.to eq hash[:name] }

  its(:visibility) { is_expected.to eq hash[:visibility] }

  describe :location do
    subject { struct.location }
    it { is_expected.to have_file }
    it { is_expected.to have_line }
    it { is_expected.to have_column }

    its(:file) { is_expected.to eq fixture('struct.rs') }
    its(:line) { is_expected.to eq hash[:location][:line] }
    its(:column) { is_expected.to eq hash[:location][:column] }
  end

  describe :fields do
    subject { struct.fields }
    let(:expected_fields) { hash[:fields] }

    it { is_expected.to eq expected_fields }
  end

  describe :generics do
    subject { struct.generics }
    let(:expected_generics) { hash[:generics] }

    it { is_expected.to eq expected_generics }
  end
end

RSpec.describe Tabitha::Model::Struct do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  before(:each) do
    Tabitha::Engine::SourceTree.clear!
    Tabitha::Model::Struct.clear!

    Tabitha::Engine::SourceTree::load!(fixture('struct.rs'))
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Struct)
  end

  it_behaves_like "it captures the struct's definition", { 
    name: :Standard,
    visibility: :pub,
    location: { line: 16, column: 11 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: :pub,
        name: :field1,
        type: :u32,
        location: struct_loc(17, 8),
      ),
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field2,
        type: :i32,
        location: struct_loc(18, 4),
      ),
    ],
    generics: Set.new
  }

  it_behaves_like "it captures the struct's definition", {
    name: :ZST,
    visibility: nil,
    location: { line: 51, column: 7 },
    fields: Set.new,
    generics: Set.new
  }

  it_behaves_like "it captures the struct's definition", {
    name: :WeirdEmpty,
    visibility: :pub,
    location: { line: 21, column: 11 },
    fields: Set.new,
    generics: Set.new
  }

  it_behaves_like "it captures the struct's definition", {
    name: :StructWithStruct,
    visibility: nil,
    location: { line: 54, column: 7 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: :pub,
        name: :field1,
        type: :Inner,
        location: struct_loc(55, 8),
      ),
    ],
    generics: Set.new
  }

  it_behaves_like "it captures the struct's definition", {
    name: :GenericStruct,
    visibility: nil,
    location: { line: 24, column: 7 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: :pub,
        name: :field1,
        type: :T,
        location: struct_loc(25, 8),
      ),
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field2,
        type: :i32,
        location: struct_loc(26, 4),
      ),
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        location: struct_loc(24, 21),
      )
    ]
  }

  it_behaves_like "it captures the struct's definition", {
    name: :MultipleGeneric,
    visibility: :pub,
    location: { line: 29, column: 11 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: :pub,
        name: :field1,
        type: :T,
        location: struct_loc(30, 8),
      ),
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field2,
        type: :U,
        location: struct_loc(31, 4),
      ),
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        location: struct_loc(29, 27),
      ),
      Tabitha::Model::Generic::new(
        name: :U,
        location: struct_loc(29, 30),
      )
    ]
  }

  it_behaves_like "it captures the struct's definition", {
    name: :BoundedWhereGeneric,
    visibility: nil,
    location: { line: 34, column: 7 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field1,
        type: :T,
        location: struct_loc(35, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        location: struct_loc(34, 36),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :Copy,
          location: struct_loc(34, 39),
        )]
      )
    ]
  }

  it_behaves_like "it captures the struct's definition", {
    name: :BoundedGeneric,
    visibility: :pub,
    location: { line: 38, column: 11 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field1,
        type: :T,
        location: struct_loc(39, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        location: struct_loc(38, 26),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :Copy,
          location: struct_loc(38, 30),
        )]
      )
    ]
  }

  it_behaves_like "it captures the struct's definition", {
    name: :MultipleBoundedGeneric,
    visibility: nil,
    location: { line: 42, column: 7 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field1,
        type: :T,
        location: struct_loc(43, 4),
      ),
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field2,
        type: :U,
        location: struct_loc(44, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        location: struct_loc(42, 30),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :Copy,
          location: struct_loc(42, 34),
        )]
      ),
      Tabitha::Model::Generic::new(
        name: :U,
        location: struct_loc(42, 40),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :Clone,
          location: struct_loc(42, 44),
        )]
      )
    ]
  }

  it_behaves_like "it captures the struct's definition", {
    name: :MultipleBoundedWhereGeneric,
    visibility: nil,
    location: { line: 8, column: 7 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field1,
        type: :T,
        location: struct_loc(12, 4),
      ),
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field2,
        type: :U,
        location: struct_loc(13, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        location: struct_loc(9, 4),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :Copy,
          location: struct_loc(9, 7),
        )]
      ),
      Tabitha::Model::Generic::new(
        name: :U,
        location: struct_loc(10, 4),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :Clone,
          location: struct_loc(10, 7),
        )]
      )
    ]
  }

  it_behaves_like "it captures the struct's definition", {
    name: :NestedBound,
    visibility: nil,
    location: { line: 4, column: 7 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field1,
        type: :T,
        location: struct_loc(5, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        location: struct_loc(4, 19),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :"Foo<U>", # FIXME: This is not the _ideal_ form of this, I'd prefer if there was some parsing of this bound, but it's not _necessary_ right now, so I'm accepting it against my perfectionism's protest.
          location: struct_loc(4, 23),
        )]
      ),
      Tabitha::Model::Generic::new(
        name: :U,
        location: struct_loc(4, 31),
      )
    ]
  }

  it_behaves_like "it captures the struct's definition", {
    name: :NestedWhereBound,
    visibility: nil,
    location: { line: 0, column: 7 },
    fields: Set[
      Tabitha::Model::Field::new(
        visibility: nil,
        name: :field1,
        type: :T,
        location: struct_loc(1, 4),
      )
    ],
    generics: Set[
      Tabitha::Model::Generic::new(
        name: :T,
        location: struct_loc(0, 36),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :"Foo<U>",
          location: struct_loc(0, 39),
        )]
      ),
      Tabitha::Model::Generic::new(
        name: :U,
        location: struct_loc(0, 47),
        bounds: Set[Tabitha::Model::Bound::new(
          bound: :Bar,
          location: struct_loc(0, 51),
        )]
      )
    ]
  }
end

