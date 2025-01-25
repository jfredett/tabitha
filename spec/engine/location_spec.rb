require 'spec_helper'

RSpec.describe Tabitha::Engine::Location do
  describe "creation by node" do
    let(:dummy_node) { double(range: double(start_point: double(row: 1, column: 1))) }
    subject { described_class.from(src: "file", node: dummy_node) }

    let(:expected) { described_class.new(file: "file", line: 1, column: 1) }

    it { is_expected.to eq expected }
  end

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
    it { is_expected.to eql equal_location }
    it { is_expected.to_not equal equal_location }

    context "compared to a nil-file location" do
      let (:nil_file_location) { described_class.new(file: nil, line: 1, column: 1) }

      it { is_expected.to_not eq nil_file_location }
      it { is_expected.to_not eql nil_file_location }
      it { is_expected.to_not equal nil_file_location }
    end

    context "compared to nil" do
      it { is_expected.to_not eq nil }
      it { is_expected.to_not eql nil }
      it { is_expected.to_not equal nil }

      it "does not error when compared to an object that lacks methods" do
      end 
    end
  end
end
