require 'spec_helper'
require 'ronin/sql/clause'

describe SQL::Clause do
  describe "#initialize" do
    context "when given an argument" do
      let(:argument) { 1 }

      subject { described_class.new(:CLAUSE,argument) }

      it "should set the argument" do
        expect(subject.argument).to eq(argument)
      end
    end

    context "when given a block" do
      subject do
        described_class.new(:CLAUSE) { 1 }
      end

      it "should use the return value as the argument" do
        expect(subject.argument).to eq(1)
      end

      context "that accepts an argument" do
        it "should yield itself" do
        end
      end
    end
  end
end
