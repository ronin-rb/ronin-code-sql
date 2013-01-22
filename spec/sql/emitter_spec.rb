require 'spec_helper'
require 'ronin/sql/literal'
require 'ronin/sql/unary_expr'
require 'ronin/sql/binary_expr'
require 'ronin/sql/field'
require 'ronin/sql/statement'
require 'ronin/sql/statement_list'
require 'ronin/sql/emitter'

describe SQL::Emitter do
  describe "#initialize" do
    context "without options" do
      its(:space)  { should == ' ' }
      its(:quotes) { should == :single }
    end
  end

  describe "#emit_keyword" do
    context "when passed an Array of Symbols" do
      let(:keywords) { [:DROP, :TABLE] }

      it "should join the keywords" do
        subject.emit_keyword(keywords).should == "DROP TABLE"
      end

      context "when :space is set" do
        subject { described_class.new(space: '/**/') }

        it "should join the keywords" do
          subject.emit_keyword(keywords).should == "DROP/**/TABLE"
        end
      end
    end

    context "when case is :upper" do
      let(:keyword) { :select }

      subject { described_class.new(case: :upper) }

      it "should upcase the keyword" do
        subject.emit_keyword(keyword).should == 'SELECT'
      end
    end

    context "when case is :lower" do
      let(:keyword) { :SELECT }

      subject { described_class.new(case: :lower) }

      it "should upcase the keyword" do
        subject.emit_keyword(keyword).should == 'select'
      end
    end

    context "when case is :random" do
      let(:keyword) { :select }

      subject { described_class.new(case: :random) }

      it "should contain at least one upper-case character" do
        subject.emit_keyword(keyword).should =~ /[SELECT]/
      end
    end

    context "when case is nil" do
      subject { described_class.new(case: nil) }

      let(:keyword) { 'Select' }

      it "should emit the keyword as is" do
        subject.emit_keyword(keyword).should == keyword
      end
    end
  end

  describe "#emit_operator" do
    context "when the operator is a symbol" do
      it "should emit a String" do
        subject.emit_operator(:"!=").should == '!='
      end
    end

    context "otherwise" do
      subject { described_class.new(case: :lower) }

      it "should emit a keyword" do
        subject.emit_operator(:AS).should == 'as'
      end
    end
  end

  describe "#emit_null" do
    it "should emit the NULL keyword" do
      subject.emit_null.should == 'NULL'
    end
  end

  describe "#emit_false" do
    it "should emit 1=0" do
      subject.emit_false.should == '1=0'
    end
  end

  describe "#emit_true" do
    it "should emit 1=1" do
      subject.emit_true.should == '1=1'
    end
  end

  describe "#emit_integer" do
    it "should emit a String" do
      subject.emit_integer(10).should == '10'
    end
  end

  describe "#emit_decimal" do
    it "should emit a String" do
      subject.emit_decimal(2.5).should == '2.5'
    end
  end

  describe "#emit_string" do
    it "should emit a String" do
      subject.emit_string("O'Brian").should == "'O''Brian'"
    end

    context "when :quotes is :double" do
      subject { described_class.new(quotes: :double) }

      it "should double quote Strings" do
        subject.emit_string("O'Brian").should == "\"O'Brian\""
      end
    end
  end

  describe "#emit_field" do
    subject { described_class.new(case: :upper) }

    let(:field) { SQL::Field.new(:id) }

    it "should emit the name as a keyword" do
      subject.emit_field(field).should == 'ID'
    end

    context "when the field has a parent" do
      let(:parent) { SQL::Field.new(:users)     }
      let(:field)  { SQL::Field.new(:id,parent) }

      it "should emit the parent then the field name" do
        subject.emit_field(field).should == 'USERS.ID'
      end
    end
  end

  describe "#emit_list" do
    it "should emit a ',' separated list" do
      subject.emit_list([1,2,3,'foo']).should == "(1,2,3,'foo')"
    end
  end

  describe "#emit_assignments" do
    let(:values) { {x: 1, y: 2} }

    it "should emit a list of column names and values" do
      subject.emit_assignments(values).should == 'x=1,y=2'
    end
  end

  describe "#emit_argument" do
    context "when the value is a Statement" do
      let(:stmt) { SQL::Statement.new(:SELECT,1) }

      it "should wrap the statement in ( )" do
        subject.emit_argument(stmt).should == '(SELECT 1)'
      end
    end

    context "otherwise" do
      let(:value) { 'hello' }

      it "should emit the value" do
        subject.emit_argument(value).should == "'hello'"
      end
    end
  end

  describe "#emit_expression" do
    context "when the expression is a BinaryExpr" do
      context "when the operator is alphabetic" do
        subject { described_class.new(case: :upper) }

        let(:expr) { SQL::BinaryExpr.new(:id,:is,1) }

        it "should emit the operands and operator as a keyword with spaces" do
          subject.emit_expression(expr).should == 'ID IS 1'
        end
      end

      context "when the operator is symbolic" do
        let(:expr) { SQL::BinaryExpr.new(:id,:"=",1) }

        it "should emit the operands and operator without spaces" do
          subject.emit_expression(expr).should == 'id=1'
        end
      end

      context "when the left-hand operand is a Statement" do
        let(:expr) do
          SQL::BinaryExpr.new(SQL::Statement.new(:SELECT,1),:"=",1)
        end

        it "should wrap the left-hand operand in parenthesis" do
          subject.emit_expression(expr).should == '(SELECT 1)=1'
        end
      end

      context "when the right-hand operand is a Statement" do
        let(:expr) do
          SQL::BinaryExpr.new(1,:"=",SQL::Statement.new(:SELECT,1))
        end

        it "should wrap the left-hand operand in parenthesis" do
          subject.emit_expression(expr).should == '1=(SELECT 1)'
        end
      end
    end

    context "when the expression is a UnaryExpr" do
      context "when the operator is upper-case alpha" do
        let(:expr) { SQL::UnaryExpr.new(:NOT,:admin) }

        it "should emit the operand and operator with spaces" do
          subject.emit_expression(expr).should == 'NOT admin'
        end
      end

      context "when the operator is symbolic" do
        let(:expr) { SQL::UnaryExpr.new(:"-",1) }

        it "should emit the operand and operator without spaces" do
          subject.emit_expression(expr).should == '-1'
        end
      end

      context "when the operand is a Statement" do
        let(:expr) do
          SQL::UnaryExpr.new(:NOT,SQL::Statement.new(:SELECT,1))
        end

        it "should wrap the operand in parenthesis" do
          subject.emit_expression(expr).should == 'NOT (SELECT 1)'
        end
      end
    end
  end

  describe "#emit_function" do
    let(:func) { SQL::Function.new(:NOW) }

    it "should emit the function name as a keyword" do
      subject.emit_function(func).should == 'NOW()'
    end

    context "with arguments" do
      let(:func) { SQL::Function.new(:MAX,1,2) }

      it "should emit the function arguments" do
        subject.emit_function(func).should == 'MAX(1,2)'
      end
    end
  end

  describe "#emit" do
    context "when passed nil" do
      it "should emit the NULL keyword" do
        subject.emit(nil).should == 'NULL'
      end
    end

    context "when passed true" do
      it "should emit true" do
        subject.emit(true).should == '1=1'
      end
    end

    context "when passed false" do
      it "should emit false" do
        subject.emit(false).should == '1=0'
      end
    end

    context "when passed an Integer" do
      it "should emit an integer" do
        subject.emit(10).should == '10'
      end
    end

    context "when passed a Float" do
      it "should emit a decimal" do
        subject.emit(2.5).should == '2.5'
      end
    end

    context "when passed a String" do
      it "should emit a string" do
        subject.emit("O'Brian").should == "'O''Brian'"
      end
    end

    context "when passed a Literal" do
      let(:literal) { SQL::Literal.new(42) }

      it "should emit the value" do
        subject.emit(literal).should == '42'
      end
    end

    context "when passed a Field" do
      let(:table)  { SQL::Field.new(:users)    }
      let(:column) { SQL::Field.new(:id,table) }

      it "should emit a field" do
        subject.emit(column).should == 'users.id'
      end
    end

    context "when passed a Symbol" do
      it "should emit a field" do
        subject.emit(:id).should == 'id'
      end
    end

    context "when passed an Array" do
      it "should emit a list" do
        subject.emit([1,2,3,'foo']).should == "(1,2,3,'foo')"
      end
    end

    context "when passed a Hash" do
      it "should emit a list of assignments" do
        subject.emit(x: 1, y: 2).should == 'x=1,y=2'
      end
    end

    context "when passed a BinaryExpr" do
      let(:expr) { SQL::BinaryExpr.new(:id,:"=",1) }

      it "should emit an expression" do
        subject.emit(expr).should == 'id=1'
      end
    end

    context "when passed a UnaryExpr" do
      let(:expr) { SQL::UnaryExpr.new(:NOT,:admin) }

      it "should emit an expression" do
        subject.emit(expr).should == 'NOT admin'
      end
    end

    context "when passed a Function" do
      let(:func) { SQL::Function.new(:MAX,1,2) }

      it "should emit the function" do
        subject.emit(func).should == 'MAX(1,2)'
      end
    end

    context "when passed a Statment" do
      let(:stmt) { SQL::Statement.new(:SELECT,1) }

      it "should emit a statement" do
        subject.emit(stmt).should == 'SELECT 1'
      end
    end

    context "when the object responds to #to_sql" do
      let(:object) { double(:sql_object) }
      let(:sql)    { "EXEC sp_configure 'xp_cmdshell', 0;" }

      it "should call #to_sql" do
        object.stub(:to_sql).and_return(sql)

        subject.emit(object).should == sql
      end
    end

    context "otherwise" do
      let(:object) { Object.new }

      it "should raise an ArgumentError" do
        lambda {
          subject.emit(object)
        }.should raise_error(ArgumentError)
      end
    end
  end

  describe "#emit_clause" do
    let(:clause) { SQL::Clause.new(:"NOT INDEXED") }

    it "should emit the clause keyword" do
      subject.emit_clause(clause).should == "NOT INDEXED"
    end

    context "with an argument" do
      let(:argument) { 100 }
      let(:clause)   { SQL::Clause.new(:LIMIT,argument) }

      it "should also emit the clause argument" do
        subject.emit_clause(clause).should == "LIMIT #{argument}"
      end
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      let(:clause)   { SQL::Clause.new(:LIMIT,100) }

      it "should emit the custom white-space deliminater" do
        subject.emit_clause(clause).should == 'LIMIT/**/100'
      end
    end
  end

  describe "#emit_clauses" do
    let(:clauses) do
      [
        SQL::Clause.new(:LIMIT, 100),
        SQL::Clause.new(:OFFSET, 10)
      ]
    end

    it "should emit multiple clauses" do
      subject.emit_clauses(clauses).should == 'LIMIT 100 OFFSET 10'
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      it "should emit the custom white-space deliminater" do
        subject.emit_clauses(clauses).should == 'LIMIT/**/100/**/OFFSET/**/10'
      end
    end
  end

  describe "#emit_statement" do
    subject { described_class.new(case: :lower) }

    context "without an argument" do
      let(:stmt) { SQL::Statement.new(:SELECT) }

      it "should emit the statment keyword" do
        subject.emit_statement(stmt).should == 'select'
      end
    end

    context "with an argument" do
      let(:stmt) { SQL::Statement.new(:SELECT,1) }

      it "should emit the statment argument" do
        subject.emit_statement(stmt).should == 'select 1'
      end

      context "when the argument is an Array" do
        let(:stmt) { SQL::Statement.new(:SELECT,[1,2,3]) }

        it "should emit a list" do
          subject.emit_statement(stmt).should == 'select (1,2,3)'
        end

        context "with only one element" do
          let(:stmt) { SQL::Statement.new(:SELECT,[1]) }

          it "should emit the element" do
            subject.emit_statement(stmt).should == 'select 1'
          end
        end
      end

      context "with custom :space" do
        subject { described_class.new(case: :lower, space: '/**/') }

        it "should emit the custom white-space deliminater" do
          subject.emit_statement(stmt).should == 'select/**/1'
        end
      end
    end

    context "with clauses" do
      let(:stmt) { SQL::Statement.new(:SELECT,1).offset(1).limit(100) }

      it "should emit the statment argument" do
        subject.emit_statement(stmt).should == 'select 1 offset 1 limit 100'
      end

      context "with custom :space" do
        subject { described_class.new(case: :lower, space: '/**/') }

        it "should emit the custom white-space deliminater" do
          subject.emit_statement(stmt).should == 'select/**/1/**/offset/**/1/**/limit/**/100'
        end
      end
    end
  end

  describe "#emit_statement_list" do
    let(:stmts) do
      sql = SQL::StatementList.new
      sql << SQL::Statement.new(:SELECT, 1)
      sql << SQL::Statement.new([:DROP, :TABLE], :users)
      sql
    end

    it "should emit multiple statements separated by '; '" do
      subject.emit_statement_list(stmts).should == 'SELECT 1; DROP TABLE users'
    end

    context "with custom :space" do
      subject { described_class.new(space: '/**/') }

      it "should emit the custom white-space deliminater" do
        subject.emit_statement_list(stmts).should == 'SELECT/**/1;/**/DROP/**/TABLE/**/users'
      end
    end
  end
end
