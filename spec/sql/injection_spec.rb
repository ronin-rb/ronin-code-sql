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

        subject { described_class.new(escape: escape) }

        it "should default the place_holder based on the :escape type" do
          subject.place_holder.should == place_holders[escape]
        end
      end
    end

    context "with :place_holder" do
      let(:data) { 'A' }

      subject { described_class.new(place_holder: data) }

      it "should pass it to the InjectionExpr" do
        subject.expression.expression.should == data
      end
    end

    context "when a block is given" do
      subject { described_class.new { @x = 1 } }

      it "should instance_eval the block" do
        subject.instance_variable_get(:@x).should == 1
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

        context "with :space" do
          it "should emit the clauses with custom spaces" do
            subject.to_sql(space: '/**/').should == '1/**/OR/**/1=1/**/LIMIT/**/100/**/OFFSET/**/10'
          end
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

        context "with :space" do
          it "should emit the statements with custom spaces" do
            subject.to_sql(space: '/**/').should == '1/**/OR/**/1=1;/**/SELECT/**/(1,2,3)'
          end
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
