require 'spec_helper'
require 'ronin/sql/emitter'

describe SQL::Emitter do
  describe "#initialize" do
    context "with default values" do
      its(:case) { should == :upper }
    end
  end

  describe "#emit_keyword" do
    let(:keyword) { :select }

    context "when case is :upper" do
      subject { described_class.new(:case => :upper) }

      it "should upcase the keyword" do
        subject.emit_keyword(keyword).should == 'SELECT'
      end
    end

    context "when case is :lower" do
      subject { described_class.new(:case => :lower) }

      it "should upcase the keyword" do
        subject.emit_keyword(keyword).should == 'select'
      end
    end
  end

  describe "#emit_operator" do
    context "when the operator is upper-case alphabetic text" do
      it "should emit a keyword" do
        subject.emit_operator(:AS).should == 'AS'
      end
    end

    context "otherwise" do
      it "should emit a String" do
        subject.emit_operator(:"!=").should == '!='
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
  end

  describe "#emit_field" do
    it "should emit a String" do
      subject.emit_field(:id).should == 'id'
    end
  end

  describe "#emit_list" do
    it "should emit a ',' separated list" do
      subject.emit_list([1,2,3,'foo']).should == "1,2,3,'foo'"
    end
  end

  describe "#emit_expression" do
    context "when the expression is a BinaryExpr" do
      context "when the operator is upper-case alpha" do
        let(:expr) { SQL::BinaryExpr.new(:id,:IS,1) }

        it "should emit the operands and operator with spaces" do
          subject.emit_expression(expr).should == 'id IS 1'
        end
      end

      context "when the operator is symbolic" do
        let(:expr) { SQL::BinaryExpr.new(:id,:"=",1) }

        it "should emit the operands and operator without spaces" do
          subject.emit_expression(expr).should == 'id=1'
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
    end
  end

  describe "#emit_function" do
    let(:func) { SQL::Function.new(:now) }

    it "should emit the function name as a keyword" do
      subject.emit_function(func).should == 'NOW()'
    end

    context "with arguments" do
      let(:func) { SQL::Function.new(:max,1,2) }

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
        subject.emit([1,2,3,'foo']).should == "1,2,3,'foo'"
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
  end

  describe "#emit_statement" do
    let(:stmt) { SQL::Statement.new(:SELECT) }

    it "should emit the statment keyword" do
      subject.emit_statement(stmt).should == 'SELECT'
    end

    context "with an argument" do
      let(:stmt) { SQL::Statement.new(:SELECT,1) }

      it "should emit the statment argument" do
        subject.emit_statement(stmt).should == 'SELECT 1'
      end
    end

    context "with clauses" do
      let(:stmt) { SQL::Statement.new(:SELECT,1).offset(1).limit(100) }

      it "should emit the statment argument" do
        subject.emit_statement(stmt).should == 'SELECT 1 OFFSET 1 LIMIT 100'
      end
    end
  end

  describe "#emit_program" do
    let(:program) do
      sql = SQL::Program.new
      sql << SQL::Statement.new(:SELECT, 1)
      sql << SQL::Statement.new(:"DROP TABLE", :users)
      sql
    end

    it "should emit multiple statements separated by '; '" do
      subject.emit_program(program).should == [
        'SELECT 1',
        'DROP TABLE users'
      ].join('; ')
    end
  end
end
