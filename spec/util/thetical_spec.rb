require 'spec_helper'

RSpec.describe Tabitha::Util::Thetical do
  before(:all) do
    SetOfNonemptyStrings = Tabitha::Util::Thetical.define do |th|
      th.accept!(name: "Strings only") do |item|
        STDERR.puts "in global accept constraint"
        item.is_a?(String)
      end

      th.reject!(methods: [:<<], name: "nonzero-length") do |item|
        STDERR.puts "in << reject constraint"
        item.respond_to?(:length) && item.length == 0
      end

      th.accept!(name: "Unique lengths required") do |left, right|
        STDERR.puts "in global accept 2-arity constraint"
        left.length != right.length
      end.describe("Additional Description Possible")
    end
  end

  subject(:set) { SetOfNonemptyStrings.new }

  it "can add strings" do
    set << "foo"
    expect(set).to include("foo")
  end

  it "can't add non-strings" do
    expect { set << 1 }.to raise_error "Constraint: `Strings only` failed."
  end

  it "can't add empty strings" do
    expect { set << "" }.to raise_error "Constraint: `nonzero-length` failed."
  end

  it "can't add duplicate length strings" do
    set << "foo"
    expect { set << "bar" }.to raise_error "Constraint: `Unique lengths required` failed."
  end
end
