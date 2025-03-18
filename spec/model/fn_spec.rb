require 'spec_helper'

RSpec.shared_examples "it captures the function's definition" do |hash|
  subject(:function) { Tabitha::Model::Fn[hash[:name]] }

  its(:name) { is_expected.to eq hash[:name] }

  its(:visibility) { is_expected.to eq hash[:visibility] }

  describe :location do
    subject { function.location }
    it { is_expected.to have_file }
    it { is_expected.to have_line }
    it { is_expected.to have_column }

    its(:file) { is_expected.to eq fixture('fn.rs') }
    its(:line) { is_expected.to eq hash[:location][:line] }
    its(:column) { is_expected.to eq hash[:location][:column] }
  end

  describe :params do
    subject { function.params }
    let(:expected_params) { hash[:params] }

    it { is_expected.to eq expected_params }
  end

  describe :return_type do
    subject { function.return_type }
    let(:expected_return_type) { hash[:return_type] }

    it { is_expected.to eq expected_return_type }
  end

  describe :modifier do
    subject { function.modifier }
    let(:expected_modifier) { hash[:modifier] }

    it { is_expected.to eq expected_modifier }
  end
end

RSpec.describe Tabitha::Model::Fn do
  before(:all) do
    Tabitha::Engine::Query.load!
  end

  before(:each) do
    Tabitha::Engine::SourceTree.clear!
    Tabitha::Model::Fn.clear!

    Tabitha::Engine::SourceTree.load!(fixture('fn.rs'))
    Tabitha::Engine::SourceTree.parse_with(Tabitha::Query::Fn)
  end

  it_behaves_like "it captures the function's definition", {
    name: :fib,
    visibility: nil,
    location: { line: 1, column: 7 },
    params: Set[
      Tabitha::Model::Param.new(
        name: :n,
        type: :u64,
        location: fn_loc(1, 13),
      )
    ],
    return_type: :u64,
    modifier: nil
  }

  it_behaves_like "it captures the function's definition", {
    name: :async_fib,
    visibility: nil,
    location: { line: 9, column: 7 },
    params: Set[
      Tabitha::Model::Param.new(
        name: :n,
        type: :u64,
        location: fn_loc(9, 15),
      )
    ],
    return_type: :u64,
    modifier: :async
  }

  it_behaves_like "it captures the function's definition", {
    name: :priv_fib,
    visibility: nil,
    location: { line: 17, column: 7 },
    params: Set[
      Tabitha::Model::Param.new(
        name: :n,
        type: :u64,
        location: fn_loc(17, 12),
      )
    ],
    return_type: :u64,
    modifier: nil
  }

  it_behaves_like "it captures the function's definition", {
    name: :async_priv_fib,
    visibility: nil,
    location: { line: 21, column: 7 },
    params: Set[
      Tabitha::Model::Param.new(
        name: :n,
        type: :u64,
        location: fn_loc(21, 15),
      )
    ],
    return_type: :u64,
    modifier: :async
  }

  it_behaves_like "it captures the function's definition", {
    name: :generic_fib,
    visibility: nil,
    location: { line: 25, column: 7 },
    params: Set[
      Tabitha::Model::Param.new(
        name: :n,
        type: :T,
        location: fn_loc(25, 13),
      )
    ],
    return_type: :T,
    modifier: nil
  }

  it_behaves_like "it captures the function's definition", {
    name: :generic_constrained_fib,
    visibility: nil,
    location: { line: 29, column: 7 },
    params: Set[
      Tabitha::Model::Param.new(
        name: :n,
        type: :T,
        location: fn_loc(29, 17),
      )
    ],
    return_type: :T,
    modifier: nil
  }

  it_behaves_like "it captures the function's definition", {
    name: :generic_where_constrained_fib,
    visibility: nil,
    location: { line: 33, column: 7 },
    params: Set[
      Tabitha::Model::Param.new(
        name: :n,
        type: :T,
        location: fn_loc(33, 19),
      )
    ],
    return_type: :T,
    modifier: nil
  }

  it_behaves_like "it captures the function's definition", {
    name: :lifetime_fib,
    visibility: nil,
    location: { line: 37, column: 7 },
    params: Set[
      Tabitha::Model::Param.new(
        name: :n,
        type: :'&\'a u64',
        location: fn_loc(37, 15),
      )
    ],
    return_type: :u64,
    modifier: nil
  }
end
