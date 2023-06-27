require 'spec_helper'
require 'ronin/code/sql/unary_expr'

shared_examples_for "UnaryExpr" do |method,operator=method|
  describe "##{method}" do
    let(:expr) { subject.send(method) }

    it "must be a UnaryExpr" do
      expect(expr).to be_kind_of(Ronin::Code::SQL::UnaryExpr)
    end

    it "must set the operand" do
      expect(expr.operand).to eq(subject)
    end

    it "must have a '#{operator}' operator" do
      expect(expr.operator).to eq(operator)
    end
  end
end
