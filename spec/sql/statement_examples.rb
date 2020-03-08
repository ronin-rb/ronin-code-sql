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
      expect(statement.keyword).to eq(keyword)
    end

    case argument
    when Proc
      it "should accept a block" do
        expect(statement.argument).not_to be_nil
      end
    when NilClass
      it "should not have an argument" do
        expect(statement.argument).to be_nil
      end
    when Array
      it "should accept an argument" do
        expect(statement.argument).to eq(arguments)
      end
    else
      it "should accept an argument" do
        expect(statement.argument).to eq(argument)
      end
    end
  end
end
