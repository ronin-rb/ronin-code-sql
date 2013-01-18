require 'spec_helper'
require 'ronin/sql/clause'
require 'ronin/sql/clauses'

shared_examples_for "Clause" do |method,keyword,argument_or_block=nil|
  describe "##{method}" do
    case argument_or_block
    when Proc
      before { subject.send(method,&argument_or_block) }
    when Array
      let(:arguments) { argument_or_block }

      before { subject.send(method,*arguments) }
    when NilClass
      before { subject.send(method) }
    else
      let(:argument) { argument_or_block }

      before { subject.send(method,argument) }
    end

    it "should add a #{keyword} clause" do
      clause.keyword.should == keyword
    end

    case argument_or_block
    when Proc
      it "should accept a block" do
        clause.argument.should_not be_nil
      end
    when NilClass
      it "should not have an argument" do
        clause.argument.should be_nil
      end
    when Array
      it "should accept an argument" do
        clause.argument.should == arguments
      end
    else
      it "should accept an argument" do
        clause.argument.should == argument
      end
    end
  end
end

describe SQL::Clauses do
  subject { Object.new.extend(described_class) }

  let(:clause) { subject.clauses.last }
  its(:clauses) { should be_empty }

  describe "#clause" do
    let(:keyword) { :EXEC }

    before { subject.clause(keyword) }

    it "should add an arbitrary clause" do
      clause.keyword.should == keyword
    end
  end

  include_examples "Clause", :from, :FROM, :table
  include_examples "Clause", :into, :INTO, :table
  include_examples "Clause", :where, :WHERE, proc { id == 1 }
  include_examples "Clause", :join, :JOIN, :table
  include_examples "Clause", :inner_join, :"INNER JOIN", :table
  include_examples "Clause", :left_join, :"LEFT JOIN", :table
  include_examples "Clause", :right_join, :"RIGHT JOIN", :table
  include_examples "Clause", :full_join, :"FULL JOIN", :table
  include_examples "Clause", :on, :ON, proc { id == 1 }
  include_examples "Clause", :union, :UNION, proc { select(:*).from(:table) }
  include_examples "Clause", :group_by, :"GROUP BY", [:column1, :column2]
  include_examples "Clause", :having, :HAVING, proc { max(priv) > 100 }
  include_examples "Clause", :limit, :LIMIT, 100
  include_examples "Clause", :offset, :OFFSET, 20
  include_examples "Clause", :top, :TOP, 50
  include_examples "Clause", :into, :INTO, :table
  include_examples "Clause", :values, :VALUES, [1,2,3,4]
  include_examples "Clause", :default_values, :"DEFAULT VALUES"
  include_examples "Clause", :set, :SET, {:x => 1, :y => 2}
  include_examples "Clause", :indexed_by, :"INDEXED BY", :index_name
  include_examples "Clause", :not_indexed, :"NOT INDEXED"
end
