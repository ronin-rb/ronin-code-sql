require 'ronin/code/sql/select'

require 'helpers/code'
require 'code/sql/has_from_clause_examples'
require 'code/sql/has_where_clause_examples'

describe Select do
  before(:each) do
    @sql = Select.new(common_dialect)
  end

  it_should_behave_like "has a fields clause"
  it_should_behave_like "has a from clause"
  it_should_behave_like "has a where clause"

  it "should have a join clause" do
    @sql.join :users, :inner => true, :left => true

    should_have_clause(@sql,:join) do |join|
      join.table.should == :users
      join.side.should == :inner
      join.direction.should == :left
    end
  end

  it "should have a group by clause" do
    fields = [:name, :age]

    @sql.group_by(*fields)

    should_have_clause(@sql,:group_by) do |group_by|
      group_by.fields.should == fields
    end
  end

  it "should have a having clause" do
    @sql.instance_eval do
      having name == 'bob'
    end

    should_have_clause(@sql,:having) do |clause|
      clause.expr.should_not be_nil
    end
  end

  it "should have a order by clause" do
    fields = [:name, :age]

    @sql.order_by(*fields)

    should_have_clause(@sql,:order_by) do |clause|
      clause.fields.should == fields
    end
  end

  it "should have a limit clause" do
    length = 10

    @sql.limit length

    should_have_clause(@sql,:limit) do |clause|
      clause.value.should == length
    end
  end

  it "should have a limit clause" do
    index = 100

    @sql.offset index

    should_have_clause(@sql,:offset) do |clause|
      clause.value.should == index
    end
  end

  it "should have a union clause" do
    query = 'SELECT * FROM admins'

    @sql.union query

    should_have_clause(@sql,:union) do |clause|
      clause.select.should == query
    end
  end

  it "should have a union all clause" do
    query = 'SELECT * FROM admins'

    @sql.union_all query

    should_have_clause(@sql,:union_all) do |clause|
      clause.select.should == query
    end
  end

  it "should have an all rows option" do
    @sql.all_rows
    @sql.instance_variable_get('@all_rows').should == true
  end

  it "should have an distinct rows option" do
    @sql.distinct_rows
    @sql.instance_variable_get('@distinct_rows').should == true
  end
end
