require 'spec_helper'
require 'ronin/sql/unary_expr'

shared_examples_for "UnaryExpr" do |method,operator=method|
  describe "##{method}" do
    let(:expr) { subject.send(method) }

    it "should be a UnaryExpr" do
      expect(expr).to be_kind_of(SQL::UnaryExpr)
    end

    it "should set the operand" do
      expect(expr.operand).to eq(subject)
    end

    it "should have a '#{operator}' operator" do
      expect(expr.operator).to eq(operator)
    end
  end
end
