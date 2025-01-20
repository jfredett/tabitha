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
    struct Example {
      ./spec/fixtures/uml.rs:8
      .. where ..
      T : Copy
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

    # TODO: Link section, should have subsections for arrow subtypes, e.g., trait bounds, etc.
    # TODO: Generics should get types built for them scoped to the struct, e.g., `Gen_Example_T` here, then we
    # pretty-print their names using some directive in PlantUML


  UML
  }
end
