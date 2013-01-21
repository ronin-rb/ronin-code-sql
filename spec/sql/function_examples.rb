require 'spec_helper'

shared_examples_for "Function" do |method,arguments=[],additional_arguments=[]|
  describe "##{method}" do
    let(:name) { method.upcase }
    let(:func) { subject.send(method,*arguments) }

    it "should create a #{method.upcase} function" do
      func.name.should == name
    end

    unless arguments.empty?
      it "should set the arguments" do
        func.arguments.should == arguments
      end
    end

    unless additional_arguments.empty?
      context "when passed additional arguments" do
        let(:func) { subject.send(method,*additional_arguments) }

        it "should set the arguments" do
          func.arguments.should == additional_arguments
        end
      end
    end
  end
end


