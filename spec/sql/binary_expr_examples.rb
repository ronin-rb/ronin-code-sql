require 'spec_helper'
require 'ronin/code/sql/binary_expr'

shared_examples_for "BinaryExpr" do |method,operator=method|
  describe "##{method}" do
    let(:operand) { 1 }
    let(:expr)    { subject.send(method,operand) }

    it "must be a BinaryExpr" do
      expect(expr).to be_kind_of(Ronin::Code::SQL::BinaryExpr)
    end

    it "must set the left-hand side operand" do
      expect(expr.left).to eq(subject)
    end

    it "must have a '#{operator}' operator" do
      expect(expr.operator).to eq(operator)
    end

    it "must set the right-hand side operand" do
      expect(expr.right).to eq(operand)
    end
  end
end
