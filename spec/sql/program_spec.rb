require 'spec_helper'
require 'ronin/sql/program'

describe SQL::Program do
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
