require 'spec_helper'

RSpec.describe Tabitha::Util::Registry do

  before(:all) do
    class ExampleRegistryClass
      extend Tabitha::Util::Registry

      attr_reader :multiple, :keyword, :args

      def initialize(multiple:, keyword:, args:)
        @multiple = multiple
        @keyword = keyword
        @args = args
      end

      def primary_key
        keyword
      end
    end
  end

  before(:each) do
    ExampleRegistryClass.create!(multiple: 5, keyword: :other_example, args: [2, 3, 4])
  end

  subject(:created_instance) { ExampleRegistryClass.create!(multiple: 1, keyword: :keyword, args: [1, 2, 3]) }

  its(:multiple) { is_expected.to eq 1 }
  its(:keyword) { is_expected.to eq :keyword }
  its(:args) { is_expected.to eq [1, 2, 3] }

  it { is_expected.to eq ExampleRegistryClass[:keyword] }
  it { is_expected.to_not eq ExampleRegistryClass[:other_example] }
end
