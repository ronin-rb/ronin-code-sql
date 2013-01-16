require 'spec_helper'
require 'ronin/sql/clauses'

describe SQL::Clauses do
  subject { Object.new.extend(described_class) }

  let(:clause) { subject.clauses.last }
  its(:clauses) { should be_empty }

  describe "#from" do
    let(:table) { :users }

    before { subject.from(table) }

    it "should add a FROM clause" do
      clause.keyword.should == :FROM
    end

    it "should accept a table argument" do
      clause.argument.should == table
    end
  end

  describe "#where" do
    before { subject.where { id == 1 } }

    it "should add a WHERE clause" do
      clause.keyword.should == :WHERE
    end

    it "should have an expression argument" do
      clause.argument.should be_kind_of(SQL::BinaryExpr)
    end
  end

  describe "#join" do
    let(:table) { :users }

    before { subject.join(table) }

    it "should add a JOIN clause" do
      clause.keyword.should == :JOIN
    end

    it "should accept a table argument" do
      clause.argument.should == table
    end
  end

  describe "#inner_join" do
    let(:table) { :users }

    before { subject.inner_join(table) }

    it "should add a INNER JOIN clause" do
      clause.keyword.should == :"INNER JOIN"
    end

    it "should accept a table argument" do
      clause.argument.should == table
    end
  end

  describe "#left_join" do
    let(:table) { :users }

    before { subject.left_join(table) }

    it "should add a LEFT JOIN clause" do
      clause.keyword.should == :"LEFT JOIN"
    end

    it "should accept a table argument" do
      clause.argument.should == table
    end
  end

  describe "#right_join" do
    let(:table) { :users }

    before { subject.right_join(table) }

    it "should add a RIGHT JOIN clause" do
      clause.keyword.should == :"RIGHT JOIN"
    end

    it "should accept a table argument" do
      clause.argument.should == table
    end
  end

  describe "#full_join" do
    let(:table) { :users }

    before { subject.full_join(table) }

    it "should add a FULL JOIN clause" do
      clause.keyword.should == :"FULL JOIN"
    end

    it "should accept a table argument" do
      clause.argument.should == table
    end
  end

  describe "#on" do
    before { subject.on { id == 1 } }

    it "should add a ON clause" do
      clause.keyword.should == :ON
    end

    it "should have an expression argument" do
      clause.argument.should be_kind_of(SQL::BinaryExpr)
    end
  end

  describe "#union" do
    before { subject.union { select(:*).from(:users) } }

    it "should add a UNION clause" do
      clause.keyword.should == :UNION
    end

    it "should have a statement argument" do
      clause.argument.should be_kind_of(SQL::Statement)
    end
  end

  describe "#group_by" do
    let(:columns) { [:id, :keyword] }

    before { subject.group_by(*columns) }

    it "should add a GROUP BY clause" do
      clause.keyword.should == :"GROUP BY"
    end

    it "should have a columns argument" do
      clause.argument.should == columns
    end
  end

  describe "#having" do
    before { subject.having { max(priv) > 100 } }

    it "should add a HAVING clause" do
      clause.keyword.should == :HAVING
    end

    it "should have an expression argument" do
      clause.argument.should be_kind_of(SQL::BinaryExpr)
    end
  end

  describe "#limit" do
    let(:limit) { 100 }

    before { subject.limit(limit) }

    it "should add a LIMIT clause" do
      clause.keyword.should == :LIMIT
    end

    it "should have an limit argument" do
      clause.argument.should == limit
    end
  end

  describe "#offset" do
    let(:index) { 100 }

    before { subject.offset(index) }

    it "should add a OFFSET clause" do
      clause.keyword.should == :OFFSET
    end

    it "should have an offset argument" do
      clause.argument.should == index
    end
  end

  describe "#top" do
    let(:count) { 100 }

    before { subject.top(count) }

    it "should add a TOP clause" do
      clause.keyword.should == :TOP
    end

    it "should have an count argument" do
      clause.argument.should == count
    end
  end

  describe "#into" do
    let(:table) { :users }

    before { subject.into(table) }

    it "should add a INTO clause" do
      clause.keyword.should == :INTO
    end

    it "should have a table argument" do
      clause.argument.should == table
    end
  end

  describe "#values" do
    let(:values) { [1,2,3,4] }

    before { subject.values(*values) }

    it "should add a VALUES clause" do
      clause.keyword.should == :VALUES
    end

    it "should have a values argument" do
      clause.argument.should == values
    end
  end

  describe "#default_values" do
    before { subject.default_values }

    it "should add a DEFAULT VALUES clause" do
      clause.keyword.should == :"DEFAULT VALUES"
    end
  end

  describe "#set" do
    let(:values) { {:x => 1, :y => 2} }

    before { subject.set(values) }

    it "should add a SET clause" do
      clause.keyword.should == :SET
    end

    it "should have a values argument" do
      clause.argument.should == values
    end
  end

  describe "#indexed_by" do
    let(:name) { :users_name_index }

    before { subject.indexed_by(name) }

    it "should add a INDEXED BY clause" do
      clause.keyword.should == :"INDEXED BY"
    end

    it "should have a index name argument" do
      clause.argument.should == name
    end
  end

  describe "#not_indexed" do
    before { subject.not_indexed }

    it "should add a NOT INDEXED clause" do
      clause.keyword.should == :"NOT INDEXED"
    end
  end
end
