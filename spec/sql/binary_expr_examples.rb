require 'spec_helper'
require 'ronin/sql/binary_expr'

shared_examples_for "BinaryExpr" do |method,operator=method|
  describe "##{method}" do
    let(:operand) { 1 }
    let(:expr)    { subject.send(method,operand) }

    it "should be a BinaryExpr" do
      expect(expr).to be_kind_of(Ronin::SQL::BinaryExpr)
    end

    it "should set the left-hand side operand" do
      expect(expr.left).to eq(subject)
    end

    it "should have a '#{operator}' operator" do
      expect(expr.operator).to eq(operator)
    end

    it "should set the right-hand side operand" do
      expect(expr.right).to eq(operand)
    end
  end
end
