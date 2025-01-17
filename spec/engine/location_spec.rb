require 'spec_helper'

RSpec.describe Tabitha::Engine::Location do

  describe "fully specified" do
    subject { described_class.new(file: "file", line: 1, column: 1) }

    its(:file) { is_expected.to eq "file" }
    its(:line) { is_expected.to eq 1 }
    its(:column) { is_expected.to eq 1 }

    it { is_expected.to have_file }
    it { is_expected.to have_line }
    it { is_expected.to have_column }
  end

  describe "partially specified" do
    subject { described_class.new(file: "file", line: 1) }

    its(:file) { is_expected.to eq "file" }
    its(:line) { is_expected.to eq 1 }
    its(:column) { is_expected.to be_nil }

    it { is_expected.to have_file }
    it { is_expected.to have_line }
    it { is_expected.to_not have_column }
  end

  describe "unspecified" do
    subject { described_class.new }

    its(:file) { is_expected.to be_nil }
    its(:line) { is_expected.to be_nil }
    its(:column) { is_expected.to be_nil }

    it { is_expected.to_not have_file }
    it { is_expected.to_not have_line }
    it { is_expected.to_not have_column }
  end

  describe "equality" do
    subject { described_class.new(file: "file", line: 1, column: 1) }
    let (:equal_location) { described_class.new(file: "file", line: 1, column: 1) }

    it { is_expected.to eq equal_location }
  end
end
