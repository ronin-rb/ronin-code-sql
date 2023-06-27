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
      it { expect(subject.space).to eq(' ') }
      it { expect(subject.quotes).to eq(:single) }
      it { expect(subject.syntax).to be(nil) }
      it { expect(subject.comment).to be(nil) }
    end

    context "provided :quotes" do
      subject { described_class.new(quotes: 'test_quotes') }

      it 'is expected to hold it' do
        expect(subject.quotes).to eq('test_quotes')
      end
    end

    context "provided :space" do
      subject { described_class.new(space: '# test-space #') }

      it 'is expected to hold it' do
        expect(subject.space).to eq('# test-space #')
      end
    end

    context "provided :syntax" do
      subject { described_class.new(syntax: :test_syntax) }

      it 'is expected to hold it' do
        expect(subject.syntax).to eq(:test_syntax)
      end
    end

    context "provided :comment" do
      subject { described_class.new(comment: '<!-- test comment ') }

      it 'is expected to hold it' do
        expect(subject.comment).to eq('<!-- test comment ')
      end
    end
  end

  describe "#emit_keyword" do
    context "when passed an Array of Symbols" do
      let(:keywords) { [:DROP, :TABLE] }

      it "must join the keywords" do
        expect(subject.emit_keyword(keywords)).to eq("DROP TABLE")
      end

      context "when :space is set" do
        subject { described_class.new(space: '/**/') }

        it "must join the keywords" do
          expect(subject.emit_keyword(keywords)).to eq("DROP/**/TABLE")
        end
      end
    end

    context "when case is :upper" do
      let(:keyword) { :select }

      subject { described_class.new(case: :upper) }

      it "must upcase the keyword" do
        expect(subject.emit_keyword(keyword)).to eq('SELECT')
      end
    end

    context "when case is :lower" do
      let(:keyword) { :SELECT }

      subject { described_class.new(case: :lower) }

      it "must upcase the keyword" do
        expect(subject.emit_keyword(keyword)).to eq('select')
      end
    end

    context "when case is :random" do
      let(:keyword) { :select }

      subject { described_class.new(case: :random) }

      it "must contain at least one upper-case character" do
        expect(subject.emit_keyword(keyword)).to match(/\ASELECT\z/i)
      end
    end

    context "when case is nil" do
      subject { described_class.new(case: nil) }

      let(:keyword) { 'Select' }

      it "must emit the keyword as is" do
        expect(subject.emit_keyword(keyword)).to eq(keyword)
      end
    end
  end

  describe "#emit_operator" do
    context "when the operator is a symbol" do
      it "must emit a String" do
        expect(subject.emit_operator(:"!=")).to eq('!=')
      end
    end

    context "otherwise" do
      subject { described_class.new(case: :lower) }

      it "must emit a keyword" do
        expect(subject.emit_operator(:AS)).to eq('as')
      end
    end
  end

  describe "#emit_null" do
    it "must emit the NULL keyword" do
      expect(subject.emit_null).to eq('NULL')
    end
  end

  describe "#emit_false" do
    it "must emit 1=0" do
      expect(subject.emit_false).to eq('1=0')
    end
  end

  describe "#emit_true" do
    it "must emit 1=1" do
      expect(subject.emit_true).to eq('1=1')
    end
  end

  describe "#emit_comment" do
    context "when #comment is set to specific value" do
      let(:custom_comment) { '# -- /* custom comment ' }

      subject { described_class.new(comment: custom_comment) }

      it 'should use that value' do
        expect(subject.emit_comment).to eq(custom_comment)
      end
    end

    context "when #comment is not set" do
      context "when #syntax is nil" do
        it "must emit a comment that works everywhere '-- '" do
          expect(subject.emit_comment).to eq('-- ')
        end
      end

      context "when #syntax is :mysql" do
        subject { described_class.new(syntax: :mysql) }

        it "must emit a MySQL/MariaDB-compatible comment that starts with '-- ' or '#'" do
          expect(subject.emit_comment).to eq('-- ')
        end
      end

      context "when #syntax is :postgres" do
        subject { described_class.new(syntax: :postgres) }

        it "must emit a Postgres-compatible comment that starts with '-- '" do
          expect(subject.emit_comment).to eq('-- ')
        end
      end

      context "when #syntax is :oracle" do
        subject { described_class.new(syntax: :oracle) }

        it "must emit a Oracle-compatible comment that starts with '-- '" do
          expect(subject.emit_comment).to eq('-- ')
        end
      end

      context "when #syntax is :mssql" do
        subject { described_class.new(syntax: :mssql) }

        it "must emit a MSSQL-compatible comment that starts with '-- '" do
          expect(subject.emit_comment).to eq('-- ')
        end
      end
    end
  end

  describe "#emit_integer" do
    it "must emit a String" do
      expect(subject.emit_integer(10)).to eq('10')
    end
  end

  describe "#emit_decimal" do
    it "must emit a String" do
      expect(subject.emit_decimal(2.5)).to eq('2.5')
    end
  end

  describe "#emit_string" do
    it "must emit a String" do
      expect(subject.emit_string("O'Brian")).to eq("'O''Brian'")
    end

    context "when :quotes is :double" do
      subject { described_class.new(quotes: :double) }

      it "must double quote Strings" do
        expect(subject.emit_string("O'Brian")).to eq("\"O'Brian\"")
      end
    end
  end

  describe "#emit_field" do
    subject { described_class.new(case: :upper) }

    let(:field) { Ronin::Code::SQL::Field.new(:id) }

    it "must emit the name as a keyword" do
      expect(subject.emit_field(field)).to eq('ID')
    end

    context "when the field has a parent" do
      let(:parent) { Ronin::Code::SQL::Field.new(:users)     }
      let(:field)  { Ronin::Code::SQL::Field.new(:id,parent) }

      it "must emit the parent then the field name" do
        expect(subject.emit_field(field)).to eq('USERS.ID')
      end
    end
  end

  describe "#emit_list" do
    context "when given an Array with multiple values" do
      it "must emit a ',' separated list" do
        expect(subject.emit_list([1,2,3,'foo'])).to eq("(1,2,3,'foo')")
      end
    end

    context "when given an Array with only one element" do
      it "must emit the single element without parentheses" do
        expect(subject.emit_list([1])).to eq('1')
      end
    end
  end

  describe "#emit_assignments" do
    let(:values) { {x: 1, y: 2} }

    it "must emit a list of column names and values" do
      expect(subject.emit_assignments(values)).to eq('x=1,y=2')
    end
  end

  describe "#emit_argument" do
    context "when the value is a Statement" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,1) }

      it "must wrap the statement in ( )" do
        expect(subject.emit_argument(stmt)).to eq('(SELECT 1)')
      end
    end

    context "otherwise" do
      let(:value) { 'hello' }

      it "must emit the value" do
        expect(subject.emit_argument(value)).to eq("'hello'")
      end
    end
  end

  describe "#emit_expression" do
    context "when the expression is a BinaryExpr" do
      context "when the operator is alphabetic" do
        subject { described_class.new(case: :upper) }

        let(:expr) { Ronin::Code::SQL::BinaryExpr.new(:id,:is,1) }

        it "must emit the operands and operator as a keyword with spaces" do
          expect(subject.emit_expression(expr)).to eq('ID IS 1')
        end
      end

      context "when the operator is symbolic" do
        let(:expr) { Ronin::Code::SQL::BinaryExpr.new(:id,:"=",1) }

        it "must emit the operands and operator without spaces" do
          expect(subject.emit_expression(expr)).to eq('id=1')
        end
      end

      context "when the left-hand operand is a Statement" do
        let(:expr) do
          Ronin::Code::SQL::BinaryExpr.new(
            Ronin::Code::SQL::Statement.new(:SELECT,1), :"=", 1
          )
        end

        it "must wrap the left-hand operand in parenthesis" do
          expect(subject.emit_expression(expr)).to eq('(SELECT 1)=1')
        end
      end

      context "when the right-hand operand is a Statement" do
        let(:expr) do
          Ronin::Code::SQL::BinaryExpr.new(
            1, :"=", Ronin::Code::SQL::Statement.new(:SELECT,1)
          )
        end

        it "must wrap the left-hand operand in parenthesis" do
          expect(subject.emit_expression(expr)).to eq('1=(SELECT 1)')
        end
      end
    end

    context "when the expression is a UnaryExpr" do
      context "when the operator is upper-case alpha" do
        let(:expr) { Ronin::Code::SQL::UnaryExpr.new(:NOT,:admin) }

        it "must emit the operand and operator with spaces" do
          expect(subject.emit_expression(expr)).to eq('NOT admin')
        end
      end

      context "when the operator is symbolic" do
        let(:expr) { Ronin::Code::SQL::UnaryExpr.new(:-,1) }

        it "must emit the operand and operator without spaces" do
          expect(subject.emit_expression(expr)).to eq('-1')
        end
      end

      context "when the operand is a Statement" do
        let(:expr) do
          Ronin::Code::SQL::UnaryExpr.new(
            :NOT, Ronin::Code::SQL::Statement.new(:SELECT,1)
          )
        end

        it "must wrap the operand in parenthesis" do
          expect(subject.emit_expression(expr)).to eq('NOT (SELECT 1)')
        end
      end
    end
  end

  describe "#emit_function" do
    let(:func) { Ronin::Code::SQL::Function.new(:NOW) }

    it "must emit the function name as a keyword" do
      expect(subject.emit_function(func)).to eq('NOW()')
    end

    context "with arguments" do
      let(:func) { Ronin::Code::SQL::Function.new(:MAX,1,2) }

      it "must emit the function arguments" do
        expect(subject.emit_function(func)).to eq('MAX(1,2)')
      end
    end
  end

  describe "#emit" do
    context "when passed nil" do
      it "must emit the NULL keyword" do
        expect(subject.emit(nil)).to eq('NULL')
      end
    end

    context "when passed true" do
      it "must emit true" do
        expect(subject.emit(true)).to eq('1=1')
      end
    end

    context "when passed false" do
      it "must emit false" do
        expect(subject.emit(false)).to eq('1=0')
      end
    end

    context "when passed an Integer" do
      it "must emit an integer" do
        expect(subject.emit(10)).to eq('10')
      end
    end

    context "when passed a Float" do
      it "must emit a decimal" do
        expect(subject.emit(2.5)).to eq('2.5')
      end
    end

    context "when passed a String" do
      it "must emit a string" do
        expect(subject.emit("O'Brian")).to eq("'O''Brian'")
      end
    end

    context "when passed a Literal" do
      let(:literal) { Ronin::Code::SQL::Literal.new(42) }

      it "must emit the value" do
        expect(subject.emit(literal)).to eq('42')
      end
    end

    context "when passed a Field" do
      let(:table)  { Ronin::Code::SQL::Field.new(:users)    }
      let(:column) { Ronin::Code::SQL::Field.new(:id,table) }

      it "must emit a field" do
        expect(subject.emit(column)).to eq('users.id')
      end
    end

    context "when passed a Symbol" do
      it "must emit a field" do
        expect(subject.emit(:id)).to eq('id')
      end
    end

    context "when passed an Array" do
      it "must emit a list" do
        expect(subject.emit([1,2,3,'foo'])).to eq("(1,2,3,'foo')")
      end
    end

    context "when passed a Hash" do
      it "must emit a list of assignments" do
        expect(subject.emit(x: 1, y: 2)).to eq('x=1,y=2')
      end
    end

    context "when passed a BinaryExpr" do
      let(:expr) { Ronin::Code::SQL::BinaryExpr.new(:id,:"=",1) }

      it "must emit an expression" do
        expect(subject.emit(expr)).to eq('id=1')
      end
    end

    context "when passed a UnaryExpr" do
      let(:expr) { Ronin::Code::SQL::UnaryExpr.new(:NOT,:admin) }

      it "must emit an expression" do
        expect(subject.emit(expr)).to eq('NOT admin')
      end
    end

    context "when passed a Function" do
      let(:func) { Ronin::Code::SQL::Function.new(:MAX,1,2) }

      it "must emit the function" do
        expect(subject.emit(func)).to eq('MAX(1,2)')
      end
    end

    context "when passed a Statment" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,1) }

      it "must emit a statement" do
        expect(subject.emit(stmt)).to eq('SELECT 1')
      end
    end

    context "when the object responds to #to_sql" do
      let(:object) { double(:sql_object) }
      let(:sql)    { "EXEC sp_configure 'xp_cmdshell', 0;" }

      it "must call #to_sql" do
        allow(object).to receive(:to_sql).and_return(sql)

        expect(subject.emit(object)).to eq(sql)
      end
    end

    context "otherwise" do
      let(:object) { Object.new }

      it "must raise an ArgumentError" do
        expect {
          subject.emit(object)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#emit_clause" do
    let(:clause) { Ronin::Code::SQL::Clause.new(:"NOT INDEXED") }

    it "must emit the clause keyword" do
      expect(subject.emit_clause(clause)).to eq("NOT INDEXED")
    end

    context "with an argument" do
      let(:argument) { 100 }
      let(:clause)   { Ronin::Code::SQL::Clause.new(:LIMIT,argument) }

      it "must also emit the clause argument" do
        expect(subject.emit_clause(clause)).to eq("LIMIT #{argument}")
      end
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      let(:clause) { Ronin::Code::SQL::Clause.new(:LIMIT,100) }

      it "must emit the custom white-space deliminater" do
        expect(subject.emit_clause(clause)).to eq('LIMIT/**/100')
      end
    end
  end

  describe "#emit_clauses" do
    let(:clauses) do
      [
        Ronin::Code::SQL::Clause.new([:ORDER, :BY], 3),
        Ronin::Code::SQL::Clause.new(:LIMIT, 100),
        Ronin::Code::SQL::Clause.new(:OFFSET, 10)
      ]
    end

    it "must emit multiple clauses" do
      expect(subject.emit_clauses(clauses)).to eq('ORDER BY 3 LIMIT 100 OFFSET 10')
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      it "must emit the custom white-space deliminater" do
        expect(subject.emit_clauses(clauses)).to eq('ORDER/**/BY/**/3/**/LIMIT/**/100/**/OFFSET/**/10')
      end
    end
  end

  describe "#emit_statement" do
    subject { described_class.new(case: :lower) }

    context "without an argument" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT) }

      it "must emit the statment keyword" do
        expect(subject.emit_statement(stmt)).to eq('select')
      end
    end

    context "with an argument" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,1) }

      it "must emit the statment argument" do
        expect(subject.emit_statement(stmt)).to eq('select 1')
      end

      context "with `order by` clasule " do
        let(:stmt_order_by) { Ronin::Code::SQL::Statement.new(:SELECT,1).order_by([1, :col_x]) }

        it "must emit order_by with multiple columns" do
          expect(subject.emit_statement(stmt_order_by)).to eq('select 1 order by (1,col_x)')
        end
      end

      context "when the argument is an Array" do
        let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,[1,2,3]) }

        it "must emit a list" do
          expect(subject.emit_statement(stmt)).to eq('select (1,2,3)')
        end

        context "with only one element" do
          let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,[1]) }

          it "must emit the element" do
            expect(subject.emit_statement(stmt)).to eq('select 1')
          end
        end
      end

      context "with custom :space" do
        subject { described_class.new(case: :lower, space: '/**/') }

        it "must emit the custom white-space deliminater" do
          expect(subject.emit_statement(stmt)).to eq('select/**/1')
        end
      end
    end

    context "with clauses" do
      let(:stmt) { Ronin::Code::SQL::Statement.new(:SELECT,1).offset(1).limit(100) }

      it "must emit the statment argument" do
        expect(subject.emit_statement(stmt)).to eq('select 1 offset 1 limit 100')
      end

      context "with custom :space" do
        subject { described_class.new(case: :lower, space: '/**/') }

        it "must emit the custom white-space deliminater" do
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

    it "must emit multiple statements separated by '; '" do
      expect(subject.emit_statement_list(stmts)).to eq('SELECT 1; DROP TABLE users')
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      it "must emit the custom white-space deliminater" do
        expect(subject.emit_statement_list(stmts)).to eq('SELECT/**/1;/**/DROP/**/TABLE/**/users')
      end
    end
  end
end
