require 'ronin/code/sql/insert'

require 'helpers/code'
require 'code/sql/has_fields_clause_examples'

describe Insert do
  before(:each) do
    @sql = Insert.new(common_dialect)
  end

  it_should_behave_like "has a fields clause"

  it "should have a default values clause" do
    @sql.default_values
    @sql.has_clause?(:default_values)
  end

  it "should have a values clause" do
    values = [1,'bob','secret']

    @sql.values values

    @sql.has_clause?(:values)
    @sql.get_clause(:values).values.should == values
  end

  it "should have a table option" do
    @sql.table :users
    @sql.instance_variable_get('@table').should == :users
  end
end
