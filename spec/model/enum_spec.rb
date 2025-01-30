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

RSpec.describe Tabitha::Model::Struct do
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
    generics: {}
  }
end
