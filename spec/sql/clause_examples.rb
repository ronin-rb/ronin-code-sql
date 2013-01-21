require 'spec_helper'

shared_examples_for "Clause" do |method,keyword,argument_or_block=nil|
  describe "##{method}" do
    case argument_or_block
    when Proc
      before { subject.send(method,&argument_or_block) }
    when Array
      let(:arguments) { argument_or_block }

      before { subject.send(method,*arguments) }
    when NilClass
      before { subject.send(method) }
    else
      let(:argument) { argument_or_block }

      before { subject.send(method,argument) }
    end

    it "should add a #{keyword} clause" do
      clause.keyword.should == keyword
    end

    case argument_or_block
    when Proc
      it "should accept a block" do
        clause.argument.should_not be_nil
      end
    when NilClass
      it "should not have an argument" do
        clause.argument.should be_nil
      end
    when Array
      it "should accept an argument" do
        clause.argument.should == arguments
      end
    else
      it "should accept an argument" do
        clause.argument.should == argument
      end
    end
  end
end
