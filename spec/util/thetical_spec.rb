require 'spec_helper'

RSpec.describe Tabitha::Util::Thetical do
  before(:all) do
    SetOfNonemptyStrings = Tabitha::Util::Thetical.define do |th|
      th.accept! do |item|
        item.is_a?(String)
      end

      th.reject!(:<<) do |item|
        item.respond_to?(:length) && item.length == 0
      end
    end
  end

  subject(:set) { SetOfNonemptyStrings.new }

  it "can add strings" do
    set << "foo"
    expect(set).to include("foo")
  end

  it "can't add non-strings" do
    expect { set << 1 }.to raise_error "Constraint failed."
  end
end
