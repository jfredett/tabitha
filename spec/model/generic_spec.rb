require 'spec_helper'

RSpec.shared_examples "it renders generics correctly" do |hash|
  subject { Tabitha::Model::Struct[hash[:struct]] }

  its(:generic_span) { is_expected.to eq hash[:short] }
  it { expect(subject.generic_span(with_bounds: true)).to eq hash[:long] }
end

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

    Tabitha::Engine::SourceTree::load!(fixture('struct.rs'))
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Struct)
  end

  it_behaves_like "it renders generics correctly", { struct: :Standard, short: nil, long: nil }
  it_behaves_like "it renders generics correctly", { struct: :ZST, short: nil, long: nil }
  it_behaves_like "it renders generics correctly", { struct: :WeirdEmpty, short: nil, long: nil }
  it_behaves_like "it renders generics correctly", { struct: :StructWithStruct, short: nil, long: nil }

  it_behaves_like "it renders generics correctly", { struct: :GenericStruct, short: "T", long: "T" }
  it_behaves_like "it renders generics correctly", { struct: :MultipleGeneric, short: "T, U", long: "T, U" }
  it_behaves_like "it renders generics correctly", { struct: :BoundedGeneric, short: "T", long: "T : Copy" }
  it_behaves_like "it renders generics correctly", { struct: :MultipleBoundedGeneric, short: "T, U", long: "T : Copy, U : Clone" }
  it_behaves_like "it renders generics correctly", { struct: :MultiplyBoundedSingleGeneric, short: "T", long: "T : Copy + Clone" }
  it_behaves_like "it renders generics correctly", { struct: :NestedBound, short: "T, U", long: "T : Foo<U>, U" }
  #FIXME: it_behaves_like "it renders generics correctly", { struct: :NestedBoundWhere, short: "T, U"  , long: "T : Foo<U>, U : Bar" }
  it_behaves_like "it renders generics correctly", { struct: :MultipleBoundedWhereGeneric, short: "T, U", long: "T : Copy, U : Clone" }
  it_behaves_like "it renders generics correctly", { struct: :BoundedWhereGeneric, short: "T", long: "T : Copy" }

end
