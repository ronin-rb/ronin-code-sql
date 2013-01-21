require 'spec_helper'
require 'ronin/sql/injection'

describe SQL::Injection do
  describe "PLACE_HOLDERS" do
    subject { described_class::PLACE_HOLDERS }

    it { should include(integer: 1)   }
    it { should include(decimal: 1.0) }
    it { should include(string: '1')  }
    it { should include(list: [nil])  }
    it { should include(column: :id)  }
  end

  describe "#initialize" do
    context "with no arguments" do
      its(:escape)       { should == :integer }
      its(:place_holder) { should == 1 }
    end

    context "with :escape" do
      context "with no :place_holder" do
        let(:place_holders) { described_class::PLACE_HOLDERS }
        let(:escape) { :string }

        subject { described_class.new(:escape => escape) }

        it "should default the place_holder based on the :escape type" do
          subject.place_holder.should == place_holders[escape]
        end
      end
    end

    context "with :place_holder" do
      let(:data) { 'A' }

      subject { described_class.new(:place_holder => data) }

      its(:place_holder) { should == data }
      its(:expression)   { should == data }
    end

    context "when a block is given" do
      subject { described_class.new { @x = 1 } }

      it "should instance_eval the block" do
        subject.instance_variable_get(:@x).should == 1
      end
    end
  end

  describe "#and" do
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
    context "without an expression" do
      subject { described_class.new(place_holder: 1) }

      it "should still emit the place-holder value" do
        subject.to_sql.should == '1'
      end

      context "with clauses" do
        subject do
          sqli = described_class.new(place_holder: 1)
          sqli.limit(100).offset(10)
          sqli
        end

        it "should emit the clauses" do
          subject.to_sql.should == '1 LIMIT 100 OFFSET 10'
        end
      end
    end

    context "with an expression" do
      subject do
        sqli = described_class.new
        sqli.or { 1 == 1 }
        sqli
      end

      it "should emit the expression" do
        subject.to_sql.should == '1 OR 1=1'
      end

      context "with clauses" do
        subject do
          sqli = described_class.new
          sqli.or { 1 == 1 }.limit(100).offset(10)
          sqli
        end

        it "should emit the clauses" do
          subject.to_sql.should == '1 OR 1=1 LIMIT 100 OFFSET 10'
        end
      end

      context "with statements" do
        subject do
          sqli = described_class.new
          sqli.or { 1 == 1 }.select(1,2,3)
          sqli
        end

        it "should emit the clauses" do
          subject.to_sql.should == '1 OR 1=1; SELECT (1,2,3)'
        end
      end
    end

    context "when escaping a string value" do
      context "when the place-holder and last operand are Strings" do
        subject do
          sqli = described_class.new(escape: :string)
          sqli.or { string(1) == string(1) }
          sqli
        end 

        it "should balance the quotes" do
          subject.to_sql.should == "1' OR '1'='1"
        end
      end

      context "when the place-holder and last operand are not both Strings" do
        subject do
          sqli = described_class.new(escape: :string)
          sqli.or { int(1) == int(1) }
          sqli
        end 

        it "should terminate the SQL statement" do
          subject.to_sql.should == "1' OR 1=1;--"
        end
      end

      context "when terminating" do
        subject do
          sqli = described_class.new(escape: :string)
          sqli.or { string(1) == string(1) }
          sqli
        end 

        it "should terminate the SQL statement" do
          subject.to_sql(terminate: true).should == "1' OR '1'='1';--"
        end
      end
    end

    context "when terminating" do
      subject do
        sqli = described_class.new(escape: :integer)
        sqli.or { 1 == 1 }
        sqli
      end 

      it "should terminate the SQL statement" do
        subject.to_sql(terminate: true).should == "1 OR 1=1;--"
      end
    end
  end
end
