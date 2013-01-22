require 'spec_helper'
require 'ronin/sql/injection_expr'

describe SQL::InjectionExpr do
  let(:initial_value) { 1 }

  subject { described_class.new(initial_value) }

  describe "#and" do
    context "on first call" do
      before { subject.and { 1 } }

      it "should create a 'AND' BinaryExpr" do
        subject.expression.operator.should == :AND
      end

      it "should create an expression with the initial value" do
        subject.expression.left.should == initial_value
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

      it "should create an expression with the initial value" do
        subject.expression.left.should == initial_value
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
    context "without additional expressions" do
      subject { described_class.new(1) }

      it "should still emit the initial value" do
        subject.to_sql.should == '1'
      end
    end

    context "with an additional expression" do
      subject do
        sqli = described_class.new(1)
        sqli.or { 1 == 1 }
        sqli
      end

      it "should emit the expression" do
        subject.to_sql.should == '1 OR 1=1'
      end

      context "when given emitter options" do
        it "should accept additional options" do
          subject.to_sql(case: :lower).should == '1 or 1=1'
        end
      end
    end
  end
end
