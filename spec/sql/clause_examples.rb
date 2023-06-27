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

    it "must add a #{keyword} clause" do
      expect(clause.keyword).to eq(keyword)
    end

    case argument_or_block
    when Proc
      it "must accept a block" do
        expect(clause.argument).not_to be_nil
      end
    when NilClass
      it "must not have an argument" do
        expect(clause.argument).to be_nil
      end
    when Array
      it "must accept an argument" do
        expect(clause.argument).to eq(arguments)
      end
    else
      it "must accept an argument" do
        expect(clause.argument).to eq(argument)
      end
    end
  end
end
