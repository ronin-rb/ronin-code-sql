require 'spec_helper'
require 'ronin/code/sql/clause'

describe Ronin::Code::SQL::Clause do
  describe "#initialize" do
    context "when given an argument" do
      let(:argument) { 1 }

      subject { described_class.new(:CLAUSE,argument) }

      it "must set the argument" do
        expect(subject.argument).to eq(argument)
      end
    end

    context "when given a block" do
      subject do
        described_class.new(:CLAUSE) { 1 }
      end

      it "must use the return value as the argument" do
        expect(subject.argument).to eq(1)
      end

      context "that accepts an argument" do
        it "must yield itself"
      end
    end
  end
end
