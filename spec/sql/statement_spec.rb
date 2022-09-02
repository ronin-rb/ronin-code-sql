require 'spec_helper'
require 'ronin/code/sql/statement'

describe Ronin::Code::SQL::Statement do
  describe "#initialize" do
    context "when given an argument" do
      let(:argument) { 1 }

      subject { described_class.new(:STATEMENT,argument) }

      it "should set the argument" do
        expect(subject.argument).to eq(argument)
      end
    end

    context "when given a block" do
      subject do
        described_class.new(:STATEMENT) { @x = 1 }
      end

      it "should instance_eval the block" do
        expect(subject.instance_variable_get(:@x)).to eq(1)
      end

      context "that accepts an argument" do
        it "should yield itself" do
          yielded_statement = nil

          described_class.new(:STATEMENT) do |stmt|
            yielded_statement = stmt
          end

          expect(yielded_statement).to be_kind_of(described_class)
        end
      end
    end
  end
end
