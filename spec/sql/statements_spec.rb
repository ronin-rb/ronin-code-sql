require 'spec_helper'
require 'ronin/sql/statement'
require 'ronin/sql/statements'

shared_examples_for "Statement" do |method,keyword,argument=nil|
  describe "##{method}" do
    case argument
    when Array
      let(:arguments) { argument }

      let(:statement) { subject.send(method,*arguments) }
    when NilClass
      let(:statement) { subject.send(method) }
    else
      let(:statement) { subject.send(method,argument) }
    end

    it "should add a #{keyword} clause" do
      statement.keyword.should == keyword
    end

    case argument
    when Proc
      it "should accept a block" do
        statement.argument.should_not be_nil
      end
    when NilClass
      it "should not have an argument" do
        statement.argument.should be_nil
      end
    when Array
      it "should accept an argument" do
        statement.argument.should == arguments
      end
    else
      it "should accept an argument" do
        statement.argument.should == argument
      end
    end
  end
end

describe SQL::Statements do
  subject { Object.new.extend(described_class) }

  describe "#statement" do
    let(:keyword) { :EXEC }

    it "should create an arbitrary statement" do
      subject.statement(keyword).keyword.should == keyword
    end
  end

  include_examples "Statement", :select, :SELECT, [1,2,3,:id]
  include_examples "Statement", :insert, :INSERT
  include_examples "Statement", :update, :UPDATE, :table
  include_examples "Statement", :delete, :"DELETE FROM", :table
end
