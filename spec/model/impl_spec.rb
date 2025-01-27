require 'spec_helper'


RSpec.describe Tabitha::Model::Impl do

  before(:all) do
    Tabitha::Engine::Query.load!
  end

  before(:each) do
    Tabitha::Engine::SourceTree.clear!
    Tabitha::Model::Struct.clear!

    # TODO: We're loading both struct and impl, so that I can also test the association between the two, ideally this'd
    # be separate to the tune of an integration test for both, but easiest to do them together right now.
    Tabitha::Engine::SourceTree::load!(fixture('struct.rs'))
    # NOTE: Loading from two different files to ensure we properly associate to the same struct across multiple files.
    Tabitha::Engine::SourceTree::load!(fixture('impl-1.rs'))
    Tabitha::Engine::SourceTree::load!(fixture('impl-2.rs'))

    # Now parse.
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Struct)
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Impl)
  end

  it { expect(Tabitha::Model::Struct[:Standard].impls).to_not be_empty }
  it { expect(Tabitha::Model::Struct[:MultipleBoundedGeneric].impls).to_not be_empty }
  it { expect(Tabitha::Model::Struct[:ZST].impls).to be_empty }

end
