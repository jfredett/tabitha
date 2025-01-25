require 'spec_helper'

RSpec.shared_examples "it renders generics correctly" do |hash|
  subject { Tabitha::Model::Struct[hash[:struct]] }

  its(:generic_span) { is_expected.to eq hash[:short] }
  it { expect(subject.generic_span(with_constraints: true)).to eq hash[:long] }
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

    Tabitha::Engine::SourceTree::load!(fixture('scratch.rs'))
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Struct)
  end

  it_behaves_like "it renders generics correctly", { struct: :Standard, short: nil, long: nil }
  it_behaves_like "it renders generics correctly", { struct: :ZST, short: nil, long: nil }
  it_behaves_like "it renders generics correctly", { struct: :WeirdEmpty, short: nil, long: nil }
  it_behaves_like "it renders generics correctly", { struct: :StructWithStruct, short: nil, long: nil }

  it_behaves_like "it renders generics correctly", { struct: :GenericStruct, short: "T", long: "T" }
  it_behaves_like "it renders generics correctly", { struct: :MultipleGeneric, short: "T, U", long: "T, U" }
  it_behaves_like "it renders generics correctly", { struct: :ConstrainedGeneric, short: "T", long: "T : Copy" }
  it_behaves_like "it renders generics correctly", { struct: :MultipleConstrainedGeneric, short: "T, U", long: "T : Copy, U : Clone" }
  it_behaves_like "it renders generics correctly", { struct: :MultiplyConstrainedSingleGeneric, short: "T", long: "T : Copy + Clone" }
  it_behaves_like "it renders generics correctly", { struct: :NestedConstraint, short: "T, U", long: "T : Foo<U>, U" }
  # FIXME: Failing case, likely because where parsing is busted? Good time to refactor to inner generic
  it_behaves_like "it renders generics correctly", { struct: :NestedConstraintWhere, short: "T, U"  , long: "T : Foo<U>, U : Bar" }
  it_behaves_like "it renders generics correctly", { struct: :MultipleConstrainedWhereGeneric, short: "T, U", long: "T : Copy, U : Clone" }
  it_behaves_like "it renders generics correctly", { struct: :ConstrainedWhereGeneric, short: "T", long: "T : Copy" }

end
