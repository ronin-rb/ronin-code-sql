require 'spec_helper'

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
