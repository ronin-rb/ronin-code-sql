require 'ronin/code/sql/replace'

require 'helpers/code'
require 'code/sql/has_fields_clause_examples'
require 'code/sql/has_default_values_clause_examples'
require 'code/sql/has_values_clause_examples'

describe Replace do
  before(:each) do
    @sql = Replace.new(common_dialect)
  end

  it_should_behave_like 'has a fields clause'
  it_should_behave_like 'has a default values clause'
  it_should_behave_like 'has a values clause'

  it "should have a table option" do
    @sql.table :users
    @sql.instance_variable_get('@table').should == :users
  end
end
