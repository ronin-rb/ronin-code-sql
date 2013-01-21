require 'spec_helper'
require 'ronin/sql/unary_expr'

shared_examples_for "UnaryExpr" do |method,operator=method|
  describe "##{method}" do
    let(:expr) { subject.send(method) }

    it "should be a UnaryExpr" do
      expr.should be_kind_of(SQL::UnaryExpr)
    end

    it "should set the operand" do
      expr.operand.should == subject
    end

    it "should have a '#{operator}' operator" do
      expr.operator.should == operator
    end
  end
end
