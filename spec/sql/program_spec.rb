require 'spec_helper'
require 'ronin/sql/program'

describe SQL::Program do
  describe "#initialize" do
    context "when given a block" do
      subject do
        described_class.new { @x = 1 }
      end

      it "should instance_eval the block" do
        subject.instance_variable_get(:@x).should == 1
      end

      context "that accepts an argument" do
        it "should yield itself" do
          yielded_program = nil

          described_class.new do |program|
            yielded_program = program
          end

          yielded_program.should be_kind_of(described_class)
        end
      end
    end
  end

  describe "#<<" do
    let(:keyword) { :SELECT }

    before { subject << SQL::Statement.new(keyword) }

    it "should append a new statement" do
      subject.statements.last.keyword.should == keyword
    end
  end

  describe "#statement" do
    let(:keyword) { [:ALTER, :TABLE] }

    before { subject.statement(keyword) }

    it "should create and append a new Statement" do
      subject.statements.last.keyword.should == keyword
    end
  end
end
