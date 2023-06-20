require 'spec_helper'
require 'ronin/code/sql/literal'
require 'ronin/code/sql/unary_expr'
require 'ronin/code/sql/binary_expr'
require 'ronin/code/sql/field'
require 'ronin/code/sql/statement'
require 'ronin/code/sql/statement_list'
require 'ronin/code/sql/emitter'

describe Ronin::Code::SQL::Emitter do
  describe "#initialize" do
    context "without options" do
      it { expect(subject.space).to  eq(' ')     }
      it { expect(subject.quotes).to eq(:single) }
    end
  end

  describe "#emit_keyword" do
    context "when passed an Array of Symbols" do
      let(:keywords) { [:DROP, :TABLE] }

      it "should join the keywords" do
        expect(subject.emit_keyword(keywords)).to eq("DROP TABLE")
      end

      context "when :space is set" do
        subject { described_class.new(space: '/**/') }

        it "should join the keywords" do
          expect(subject.emit_keyword(keywords)).to eq("DROP/**/TABLE")
        end
      end
    end

    context "when case is :upper" do
      let(:keyword) { :select }

      subject { described_class.new(case: :upper) }

      it "should upcase the keyword" do
        expect(subject.emit_keyword(keyword)).to eq('SELECT')
      end
    end

    context "when case is :lower" do
      let(:keyword) { :SELECT }

      subject { described_class.new(case: :lower) }

      it "should upcase the keyword" do
        expect(subject.emit_keyword(keyword)).to eq('select')
      end
    end

    context "when case is :random" do
      let(:keyword) { :select }

      subject { described_class.new(case: :random) }

      it "should contain at least one upper-case character" do
        expect(subject.emit_keyword(keyword)).to match(/[SELECT]/)
      end
    end

    context "when case is nil" do
      subject { described_class.new(case: nil) }

      let(:keyword) { 'Select' }

      it "should emit the keyword as is" do
        expect(subject.emit_keyword(keyword)).to eq(keyword)
      end
    end
  end

  describe "#emit_operator" do
    context "when the operator is a symbol" do
      it "should emit a String" do
        expect(subject.emit_operator(:"!=")).to eq('!=')
      end
    end

    context "otherwise" do
      subject { described_class.new(case: :lower) }

      it "should emit a keyword" do
        expect(subject.emit_operator(:AS)).to eq('as')
      end
    end
  end

  describe "#emit_null" do
    it "should emit the NULL keyword" do
      expect(subject.emit_null).to eq('NULL')
    end
  end

  describe "#emit_false" do
    it "should emit 1=0" do
      expect(subject.emit_false).to eq('1=0')
    end
  end

  describe "#emit_true" do
    it "should emit 1=1" do
      expect(subject.emit_true).to eq('1=1')
    end
  end

  describe "#emit_comment" do
    it "should emit a String" do
      expect(subject.emit_comment).to eq('--')
    end
  end

  describe "#emit_integer" do
    it "should emit a String" do
      expect(subject.emit_integer(10)).to eq('10')
    end
  end

  describe "#emit_decimal" do
    it "should emit a String" do
      expect(subject.emit_decimal(2.5)).to eq('2.5')
    end
  end

  describe "#emit_string" do
    it "should emit a String" do
      expect(subject.emit_string("O'Brian")).to eq("'O''Brian'")
    end

    context "when :quotes is :double" do
      subject { described_class.new(quotes: :double) }

      it "should double quote Strings" do
        expect(subject.emit_string("O'Brian")).to eq("\"O'Brian\"")
      end
    end
  end

  describe "#emit_field" do
    subject { described_class.new(case: :upper) }

    let(:field) { Ronin::Code::SQL::Field.new(:id) }

    it "should emit the name as a keyword" do
      expect(subject.emit_field(field)).to eq('ID')
    end

    context "when the field has a parent" do
      let(:parent) { Ronin::Code::SQL::Field.new(:users)     }
      let(:field)  { Ronin::Code::SQL::Field.new(:id,parent) }

      it "should emit the parent then the field name" do
        expect(subject.emit_field(field)).to eq('USERS.ID')
      end
    end
  end

  describe "#emit_list" do
    it "should emit a ',' separated list" do
      expect(subject.emit_list([1,2,3,'foo'])).to eq("(1,2,3,'foo')")
    end
  end

  describe "#emit_assignments" do
    let(:values) { {x: 1, y: 2} }

    it "should emit a list of column names and values" do
      expect(subject.emit_assignments(values)).to eq('x=1,y=2')
    end
  end

  describe "#emit_argument" do
    context "when the value is a Statement" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,1) }

      it "should wrap the statement in ( )" do
        expect(subject.emit_argument(stmt)).to eq('(SELECT 1)')
      end
    end

    context "otherwise" do
      let(:value) { 'hello' }

      it "should emit the value" do
        expect(subject.emit_argument(value)).to eq("'hello'")
      end
    end
  end

  describe "#emit_expression" do
    context "when the expression is a BinaryExpr" do
      context "when the operator is alphabetic" do
        subject { described_class.new(case: :upper) }

        let(:expr) { Ronin::Code::SQL::BinaryExpr.new(:id,:is,1) }

        it "should emit the operands and operator as a keyword with spaces" do
          expect(subject.emit_expression(expr)).to eq('ID IS 1')
        end
      end

      context "when the operator is symbolic" do
        let(:expr) { Ronin::Code::SQL::BinaryExpr.new(:id,:"=",1) }

        it "should emit the operands and operator without spaces" do
          expect(subject.emit_expression(expr)).to eq('id=1')
        end
      end

      context "when the left-hand operand is a Statement" do
        let(:expr) do
          Ronin::Code::SQL::BinaryExpr.new(
            Ronin::Code::SQL::Statement.new(:SELECT,1), :"=", 1
          )
        end

        it "should wrap the left-hand operand in parenthesis" do
          expect(subject.emit_expression(expr)).to eq('(SELECT 1)=1')
        end
      end

      context "when the right-hand operand is a Statement" do
        let(:expr) do
          Ronin::Code::SQL::BinaryExpr.new(
            1, :"=", Ronin::Code::SQL::Statement.new(:SELECT,1)
          )
        end

        it "should wrap the left-hand operand in parenthesis" do
          expect(subject.emit_expression(expr)).to eq('1=(SELECT 1)')
        end
      end
    end

    context "when the expression is a UnaryExpr" do
      context "when the operator is upper-case alpha" do
        let(:expr) { Ronin::Code::SQL::UnaryExpr.new(:NOT,:admin) }

        it "should emit the operand and operator with spaces" do
          expect(subject.emit_expression(expr)).to eq('NOT admin')
        end
      end

      context "when the operator is symbolic" do
        let(:expr) { Ronin::Code::SQL::UnaryExpr.new(:"-",1) }

        it "should emit the operand and operator without spaces" do
          expect(subject.emit_expression(expr)).to eq('-1')
        end
      end

      context "when the operand is a Statement" do
        let(:expr) do
          Ronin::Code::SQL::UnaryExpr.new(
            :NOT, Ronin::Code::SQL::Statement.new(:SELECT,1)
          )
        end

        it "should wrap the operand in parenthesis" do
          expect(subject.emit_expression(expr)).to eq('NOT (SELECT 1)')
        end
      end
    end
  end

  describe "#emit_function" do
    let(:func) { Ronin::Code::SQL::Function.new(:NOW) }

    it "should emit the function name as a keyword" do
      expect(subject.emit_function(func)).to eq('NOW()')
    end

    context "with arguments" do
      let(:func) { Ronin::Code::SQL::Function.new(:MAX,1,2) }

      it "should emit the function arguments" do
        expect(subject.emit_function(func)).to eq('MAX(1,2)')
      end
    end
  end

  describe "#emit" do
    context "when passed nil" do
      it "should emit the NULL keyword" do
        expect(subject.emit(nil)).to eq('NULL')
      end
    end

    context "when passed true" do
      it "should emit true" do
        expect(subject.emit(true)).to eq('1=1')
      end
    end

    context "when passed false" do
      it "should emit false" do
        expect(subject.emit(false)).to eq('1=0')
      end
    end

    context "when passed an Integer" do
      it "should emit an integer" do
        expect(subject.emit(10)).to eq('10')
      end
    end

    context "when passed a Float" do
      it "should emit a decimal" do
        expect(subject.emit(2.5)).to eq('2.5')
      end
    end

    context "when passed a String" do
      it "should emit a string" do
        expect(subject.emit("O'Brian")).to eq("'O''Brian'")
      end
    end

    context "when passed a Literal" do
      let(:literal) { Ronin::Code::SQL::Literal.new(42) }

      it "should emit the value" do
        expect(subject.emit(literal)).to eq('42')
      end
    end

    context "when passed a Field" do
      let(:table)  { Ronin::Code::SQL::Field.new(:users)    }
      let(:column) { Ronin::Code::SQL::Field.new(:id,table) }

      it "should emit a field" do
        expect(subject.emit(column)).to eq('users.id')
      end
    end

    context "when passed a Symbol" do
      it "should emit a field" do
        expect(subject.emit(:id)).to eq('id')
      end
    end

    context "when passed an Array" do
      it "should emit a list" do
        expect(subject.emit([1,2,3,'foo'])).to eq("(1,2,3,'foo')")
      end
    end

    context "when passed a Hash" do
      it "should emit a list of assignments" do
        expect(subject.emit(x: 1, y: 2)).to eq('x=1,y=2')
      end
    end

    context "when passed a BinaryExpr" do
      let(:expr) { Ronin::Code::SQL::BinaryExpr.new(:id,:"=",1) }

      it "should emit an expression" do
        expect(subject.emit(expr)).to eq('id=1')
      end
    end

    context "when passed a UnaryExpr" do
      let(:expr) { Ronin::Code::SQL::UnaryExpr.new(:NOT,:admin) }

      it "should emit an expression" do
        expect(subject.emit(expr)).to eq('NOT admin')
      end
    end

    context "when passed a Function" do
      let(:func) { Ronin::Code::SQL::Function.new(:MAX,1,2) }

      it "should emit the function" do
        expect(subject.emit(func)).to eq('MAX(1,2)')
      end
    end

    context "when passed a Statment" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,1) }

      it "should emit a statement" do
        expect(subject.emit(stmt)).to eq('SELECT 1')
      end
    end

    context "when the object responds to #to_sql" do
      let(:object) { double(:sql_object) }
      let(:sql)    { "EXEC sp_configure 'xp_cmdshell', 0;" }

      it "should call #to_sql" do
        allow(object).to receive(:to_sql).and_return(sql)

        expect(subject.emit(object)).to eq(sql)
      end
    end

    context "otherwise" do
      let(:object) { Object.new }

      it "should raise an ArgumentError" do
        expect {
          subject.emit(object)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#emit_clause" do
    let(:clause) { Ronin::Code::SQL::Clause.new(:"NOT INDEXED") }

    it "should emit the clause keyword" do
      expect(subject.emit_clause(clause)).to eq("NOT INDEXED")
    end

    context "with an argument" do
      let(:argument) { 100 }
      let(:clause)   { Ronin::Code::SQL::Clause.new(:LIMIT,argument) }

      it "should also emit the clause argument" do
        expect(subject.emit_clause(clause)).to eq("LIMIT #{argument}")
      end
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      let(:clause)   { Ronin::Code::SQL::Clause.new(:LIMIT,100) }

      it "should emit the custom white-space deliminater" do
        expect(subject.emit_clause(clause)).to eq('LIMIT/**/100')
      end
    end
  end

  describe "#emit_clauses" do
    let(:clauses) do
      [
        Ronin::Code::SQL::Clause.new(:LIMIT, 100),
        Ronin::Code::SQL::Clause.new(:OFFSET, 10)
      ]
    end

    it "should emit multiple clauses" do
      expect(subject.emit_clauses(clauses)).to eq('LIMIT 100 OFFSET 10')
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      it "should emit the custom white-space deliminater" do
        expect(subject.emit_clauses(clauses)).to eq('LIMIT/**/100/**/OFFSET/**/10')
      end
    end
  end

  describe "#emit_statement" do
    subject { described_class.new(case: :lower) }

    context "without an argument" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT) }

      it "should emit the statment keyword" do
        expect(subject.emit_statement(stmt)).to eq('select')
      end
    end

    context "with an argument" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,1) }

      it "should emit the statment argument" do
        expect(subject.emit_statement(stmt)).to eq('select 1')
      end

      context "when the argument is an Array" do
        let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,[1,2,3]) }

        it "should emit a list" do
          expect(subject.emit_statement(stmt)).to eq('select (1,2,3)')
        end

        context "with only one element" do
          let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,[1]) }

          it "should emit the element" do
            expect(subject.emit_statement(stmt)).to eq('select 1')
          end
        end
      end

      context "with custom :space" do
        subject { described_class.new(case: :lower, space: '/**/') }

        it "should emit the custom white-space deliminater" do
          expect(subject.emit_statement(stmt)).to eq('select/**/1')
        end
      end
    end

    context "with clauses" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,1).offset(1).limit(100) }

      it "should emit the statment argument" do
        expect(subject.emit_statement(stmt)).to eq('select 1 offset 1 limit 100')
      end

      context "with custom :space" do
        subject { described_class.new(case: :lower, space: '/**/') }

        it "should emit the custom white-space deliminater" do
          expect(subject.emit_statement(stmt)).to eq('select/**/1/**/offset/**/1/**/limit/**/100')
        end
      end
    end
  end

  describe "#emit_statement_list" do
    let(:stmts) do
      sql = Ronin::Code::SQL::StatementList.new
      sql << Ronin::Code::SQL::Statement.new(:SELECT, 1)
      sql << Ronin::Code::SQL::Statement.new([:DROP, :TABLE], :users)
      sql
    end

    it "should emit multiple statements separated by '; '" do
      expect(subject.emit_statement_list(stmts)).to eq('SELECT 1; DROP TABLE users')
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      it "should emit the custom white-space deliminater" do
        expect(subject.emit_statement_list(stmts)).to eq('SELECT/**/1;/**/DROP/**/TABLE/**/users')
      end
    end
  end
end
