require 'spec_helper'
require 'ronin/sql/statements'

describe SQL::Statements do
  subject { Object.new.extend(described_class) }

  describe "#statement" do
    let(:keyword) { :EXEC }

    it "should create an arbitrary statement" do
      subject.statement(keyword).keyword.should == keyword
    end
  end

  describe "#select" do
    it "should create a SELECT statement" do
      subject.select.keyword.should == :SELECT
    end

    context "when given multiple columns" do
      let(:columns) { [1,2,3,:id] }

      it "should set the argument" do
        subject.select(*columns).argument.should == columns
      end
    end
  end

  describe "#insert" do
    it "should create a INSERT statement" do
      subject.insert.keyword.should == :"INSERT INTO"
    end
  end

  describe "#update" do
    it "should create a UPDATE statement" do
      subject.update(:users).keyword.should == :UPDATE
    end
  end

  describe "#delete" do
    it "should create a DELETE FROM statement" do
      subject.delete(:users).keyword.should == :"DELETE FROM"
    end
  end
end
