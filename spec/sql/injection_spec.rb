require 'spec_helper'
require 'ronin/code/sql/injection'

describe Ronin::Code::SQL::Injection do
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
      it { expect(subject.escape).to       eq(:integer) }
      it { expect(subject.place_holder).to eq(1)        }
    end

    context "with :escape" do
      context "with no :place_holder" do
        let(:place_holders) { described_class::PLACE_HOLDERS }
        let(:escape) { :string }

        subject { described_class.new(escape: escape) }

        it "should default the place_holder based on the :escape type" do
          expect(subject.place_holder).to eq(place_holders[escape])
        end
      end
    end

    context "with :place_holder" do
      let(:data) { 'A' }

      subject { described_class.new(place_holder: data) }

      it "should pass it to the InjectionExpr" do
        expect(subject.expression.expression).to eq(data)
      end
    end

    context "when a block is given" do
      subject { described_class.new { @x = 1 } }

      it "should instance_eval the block" do
        expect(subject.instance_variable_get(:@x)).to eq(1)
      end
    end
  end

  describe "#to_sql" do
    context "without an expression" do
      subject { described_class.new(place_holder: 1) }

      it "should still emit the place-holder value" do
        expect(subject.to_sql).to eq('1')
      end

      context "with clauses" do
        subject do
          sqli = described_class.new(place_holder: 1)
          sqli.limit(100).offset(10)
          sqli
        end

        it "should emit the clauses" do
          expect(subject.to_sql).to eq('1 LIMIT 100 OFFSET 10')
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
        expect(subject.to_sql).to eq('1 OR 1=1')
      end

      context "with clauses" do
        subject do
          sqli = described_class.new
          sqli.or { 1 == 1 }.limit(100).offset(10)
          sqli
        end

        it "should emit the clauses" do
          expect(subject.to_sql).to eq('1 OR 1=1 LIMIT 100 OFFSET 10')
        end

        context "with :space" do
          it "should emit the clauses with custom spaces" do
            expect(subject.to_sql(space: '/**/')).to eq('1/**/OR/**/1=1/**/LIMIT/**/100/**/OFFSET/**/10')
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
          expect(subject.to_sql).to eq('1 OR 1=1; SELECT (1,2,3)')
        end

        context "with :space" do
          it "should emit the statements with custom spaces" do
            expect(subject.to_sql(space: '/**/')).to eq('1/**/OR/**/1=1;/**/SELECT/**/(1,2,3)')
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
          expect(subject.to_sql).to eq("1' OR '1'='1")
        end
      end

      context "when the place-holder and last operand are not both Strings" do
        subject do
          sqli = described_class.new(escape: :string)
          sqli.or { int(1) == int(1) }
          sqli
        end

        it "should terminate the SQL statement" do
          expect(subject.to_sql).to start_with("1' OR 1=1;-- ")
        end
      end

      context "when terminating" do
        subject do
          sqli = described_class.new(escape: :string)
          sqli.or { string(1) == string(1) }
          sqli
        end

        it "should terminate the SQL statement" do
          expect(subject.to_sql(terminate: true)).to start_with("1' OR '1'='1';-- ")
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
        expect(subject.to_sql(terminate: true)).to start_with("1 OR 1=1;-- ")
      end
    end
  end
end
