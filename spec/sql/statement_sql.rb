require 'spec_helper'
require 'ronin/sql/statement'

describe SQL::Statement do
  describe "#initialize" do
    context "when given an argument" do
      let(:argument) { 1 }

      subject { described_class.new(:STATEMENT,argument) }

      it "should set the argument" do
        subject.argument.should == argument
      end
    end

    context "when given a block" do
      subject do
        described_class.new(:STATEMENT) { @x = 1 }
      end

      it "should instance_eval the block" do
        subject.instance_variable_get(:@x).should == 1
      end

      context "that accepts an argument" do
        it "should yield itself" do
        end
      end
    end
  end
end
