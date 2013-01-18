require 'spec_helper'
require 'ronin/sql/binary_expr'
require 'ronin/sql/unary_expr'
require 'ronin/sql/operators'

shared_examples_for "BinaryExpr" do |method,operator=method|
  describe "##{method}" do
    let(:operand) { 1 }
    let(:expr)    { subject.send(method,operand) }

    it "should be a BinaryExpr" do
      expr.should be_kind_of(SQL::BinaryExpr)
    end

    it "should set the right-hand operand" do
      expr.right.should == operand
    end

    it "should have a '#{operator}' operator" do
      expr.operator.should == operator
    end
  end
end

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

describe SQL::Operators do
  subject { Object.new.extend(described_class) }

  let(:operand) { 1 }

  include_examples "BinaryExpr", :*
  include_examples "BinaryExpr", :/
  include_examples "BinaryExpr", :%
  include_examples "BinaryExpr", :+
  include_examples "BinaryExpr", :-
  include_examples "BinaryExpr", :<<
  include_examples "BinaryExpr", :>>
  include_examples "BinaryExpr", :&
  include_examples "BinaryExpr", :|
  include_examples "BinaryExpr", :<
  include_examples "BinaryExpr", :<=
  include_examples "BinaryExpr", :>
  include_examples "BinaryExpr", :>=
  include_examples "BinaryExpr", :==, :"="
  include_examples "BinaryExpr", :!=
  include_examples "BinaryExpr", :as, :AS
  include_examples "BinaryExpr", :is, :IS
  include_examples "BinaryExpr", :is_not, :"IS NOT"
  include_examples "BinaryExpr", :like, :LIKE
  include_examples "BinaryExpr", :glob, :GLOB
  include_examples "BinaryExpr", :match, :MATCH
  include_examples "BinaryExpr", :regexp, :REGEXP
  include_examples "BinaryExpr", :in, :IN

  pending "need to figure out how to send a unary operator" do
    include_examples "UnaryExpr", :-
    include_examples "UnaryExpr", :+
  end

  include_examples "UnaryExpr", :~
  include_examples "UnaryExpr", :!
  include_examples "UnaryExpr", :not, :NOT

  include_examples "BinaryExpr", :and, :AND
  include_examples "BinaryExpr", :or, :OR
end
