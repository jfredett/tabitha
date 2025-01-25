require 'spec_helper'

RSpec.describe "Tabitha::Model::Struct#to_uml" do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  before(:each) do
    Tabitha::Engine::SourceTree.clear!
    Tabitha::Model::Struct.clear!

    Tabitha::Engine::SourceTree::load!(fixture('uml.rs'))
    Tabitha::Engine::SourceTree::parse_with(Tabitha::Model::Struct)
  end

  let(:expected_uml_diagram) { <<~UML
    struct Example<T> {
      ./spec/fixtures/uml.rs:8
      .. where ..
      T : Copy + PartialEq
      .. fields ..
      pub pub_field: T
      private_field: Vec<usize>
      .. impls ..
      === Example<String> (./spec/fixtures/uml.rs:13) ===
      pub fn go(&self) -> bool
      fn stop(&mut self)
      === Example<T : Copy> (./spec/fixtures/uml.rs:24) ===
      pub fn fax(&self, message: &T, ch: Channel)
      === Example<T : Copy : Default> (./spec/fixtures/uml.rs:30) ===
      pub fn fax_spam(&self, ch: Channel)
    }

    class Gen_Example_T as T <<G, green>> {
      ./spec/fixtures/uml.rs:8
      .. bounds ..
      Copy
      PartialEq
    }

    class Gen_Example_T implements Copy
    class Gen_Example_T implements PartialEq

    class Example implements Default

    #{"Field Links" if false}
    Example::pub_field --* Gen_Example_T
    Example::private_field --* Vec<usize>
    #{"Method Links -- dotted line = produces, dashed line = consumes" if false}
    Example::go -[dotted]-|> bool
    Example::fax -[dashed]-|> Gen_Example_T
    Example::fax <|-[dashed]- Gen_Example_T
    Example::fax <|-[dashed]- Channel
    Example::fax_spam <|-[dashed]- Channel
    Example::default -[dotted]-> Example<T>
  UML
  }

  subject { Tabitha::Model::Struct[:Example] }

  # it "renders the UML diagram code as expected" do
  #   expect(subject.to_uml).to eq expected_uml_diagram
  # end

  # its(:generic_span) { is_expected.to eq "<T>" }

  # it "renders the bounds if you ask" do
  #   expect(subject.generic_span(with_bounds: true)).to eq "<T : Copy + PartialEq>"
  # end
end
