require 'spec_helper'
require 'ronin/sql/binary_expr'

shared_examples_for "BinaryExpr" do |method,operator=method|
  describe "##{method}" do
    let(:operand) { 1 }
    let(:expr)    { subject.send(method,operand) }

    it "should be a BinaryExpr" do
      expr.should be_kind_of(SQL::BinaryExpr)
    end

    it "should set the left-hand side operand" do
      expr.left.should == subject
    end

    it "should have a '#{operator}' operator" do
      expr.operator.should == operator
    end

    it "should set the right-hand side operand" do
      expr.right.should == operand
    end
  end
end
