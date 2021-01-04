require 'spec_helper'
require 'sql/clause_examples'
require 'ronin/sql/clause'
require 'ronin/sql/clauses'

describe SQL::Clauses do
  subject { Object.new.extend(described_class) }

  let(:clause) { subject.clauses.last }

  it { expect(subject.clauses).to be_empty }

  describe "#clause" do
    let(:keyword) { :EXEC }

    before { subject.clause(keyword) }

    it "should add an arbitrary clause" do
      expect(clause.keyword).to eq(keyword)
    end
  end

  include_examples "Clause", :from, :FROM, :table
  include_examples "Clause", :into, :INTO, :table
  include_examples "Clause", :where, :WHERE, proc { id == 1 }
  include_examples "Clause", :join, :JOIN, :table
  include_examples "Clause", :inner_join, [:INNER, :JOIN], :table
  include_examples "Clause", :left_join, [:LEFT, :JOIN], :table
  include_examples "Clause", :right_join, [:RIGHT, :JOIN], :table
  include_examples "Clause", :full_join, [:FULL, :JOIN], :table
  include_examples "Clause", :on, :ON, proc { id == 1 }
  include_examples "Clause", :union, :UNION, proc { select(:*).from(:table) }
  include_examples "Clause", :union_all, [:UNION, :ALL], proc {
                               select(:*).from(:table)
                             }
  include_examples "Clause", :group_by, [:GROUP, :BY], [:column1, :column2]
  include_examples "Clause", :having, :HAVING, proc { max(priv) > 100 }
  include_examples "Clause", :limit, :LIMIT, 100
  include_examples "Clause", :offset, :OFFSET, 20
  include_examples "Clause", :top, :TOP, 50
  include_examples "Clause", :into, :INTO, :table
  include_examples "Clause", :values, :VALUES, [1,2,3,4]
  include_examples "Clause", :default_values, [:DEFAULT, :VALUES]
  include_examples "Clause", :set, :SET, {x: 1, y: 2}
  include_examples "Clause", :indexed_by, [:INDEXED, :BY], :index_name
  include_examples "Clause", :not_indexed, [:NOT, :INDEXED]
end
