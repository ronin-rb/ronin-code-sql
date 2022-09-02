require 'spec_helper'
require 'ronin/code/sql/injection_expr'

describe Ronin::Code::SQL::InjectionExpr do
  let(:initial_value) { 1 }

  subject { described_class.new(initial_value) }

  describe "#and" do
    context "on first call" do
      before { subject.and { 1 } }

      it "should create a 'AND' BinaryExpr" do
        expect(subject.expression.operator).to eq(:AND)
      end

      it "should create an expression with the initial value" do
        expect(subject.expression.left).to eq(initial_value)
      end

      it "should create an expression with the expression" do
        expect(subject.expression.right).to eq(1)
      end
    end

    context "on multiple calls" do
      before { subject.and { 1 }.and { 2 } }

      it "should create another 'AND' BinaryExpr" do
        expect(subject.expression.operator).to eq(:AND)
      end

      it "should nest the expressions" do
        expect(subject.expression.left.right).to eq(1)
        expect(subject.expression.right).to eq(2)
      end
    end
  end

  describe "#or" do
    context "on first call" do
      before { subject.or { 1 } }

      it "should create a 'OR' BinaryExpr" do
        expect(subject.expression.operator).to eq(:OR)
      end

      it "should create an expression with the initial value" do
        expect(subject.expression.left).to eq(initial_value)
      end

      it "should create an expression with the expression" do
        expect(subject.expression.right).to eq(1)
      end
    end

    context "on multiple calls" do
      before { subject.or { 1 }.or { 2 } }

      it "should create another 'OR' BinaryExpr" do
        expect(subject.expression.operator).to eq(:OR)
      end

      it "should nest the expressions" do
        expect(subject.expression.left.right).to eq(1)
        expect(subject.expression.right).to eq(2)
      end
    end
  end

  describe "#to_sql" do
    context "without additional expressions" do
      subject { described_class.new(1) }

      it "should still emit the initial value" do
        expect(subject.to_sql).to eq('1')
      end
    end

    context "with an additional expression" do
      subject do
        sqli = described_class.new(1)
        sqli.or { 1 == 1 }
        sqli
      end

      it "should emit the expression" do
        expect(subject.to_sql).to eq('1 OR 1=1')
      end

      context "when given emitter options" do
        it "should accept additional options" do
          expect(subject.to_sql(case: :lower)).to eq('1 or 1=1')
        end
      end
    end
  end
end
