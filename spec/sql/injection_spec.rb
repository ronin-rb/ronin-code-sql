require 'spec_helper'
require 'ronin/sql/injection'

describe SQL::Injection do
  describe "#initialize" do
    context "with no arguments" do
      its(:escape)       { should == :column }
      its(:place_holder) { should == :id     }
    end
  end

  describe "#add" do
    context "on first call" do
      before { subject.and { 1 } }

      it "should create a 'AND' BinaryExpr" do
        subject.expression.operator.should == :AND
      end

      it "should create an expression with the place-holder" do
        subject.expression.left.should == subject.place_holder
      end

      it "should create an expression with the expression" do
        subject.expression.right.should == 1
      end
    end

    context "on multiple calls" do
      before { subject.and { 1 }.and { 2 } }

      it "should create another 'AND' BinaryExpr" do
        subject.expression.operator.should == :AND
      end

      it "should nest the expressions" do
        subject.expression.left.right.should == 1
        subject.expression.right.should == 2
      end
    end
  end

  describe "#or" do
    context "on first call" do
      before { subject.or { 1 } }

      it "should create a 'OR' BinaryExpr" do
        subject.expression.operator.should == :OR
      end

      it "should create an expression with the place-holder" do
        subject.expression.left.should == subject.place_holder
      end

      it "should create an expression with the expression" do
        subject.expression.right.should == 1
      end
    end

    context "on multiple calls" do
      before { subject.or { 1 }.or { 2 } }

      it "should create another 'OR' BinaryExpr" do
        subject.expression.operator.should == :OR
      end

      it "should nest the expressions" do
        subject.expression.left.right.should == 1
        subject.expression.right.should == 2
      end
    end
  end

  describe "#to_sql" do
  end
end
