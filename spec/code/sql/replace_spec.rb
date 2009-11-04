require 'ronin/code/sql/replace'

require 'spec_helper'
require 'code/sql/helpers/sql'
require 'code/sql/has_fields_clause_examples'
require 'code/sql/has_default_values_clause_examples'
require 'code/sql/has_values_clause_examples'

describe Code::SQL::Replace do
  include Helpers

  before(:each) do
    @sql = Code::SQL::Replace.new(common_dialect)
  end

  it_should_behave_like 'has a fields clause'
  it_should_behave_like 'has a default values clause'
  it_should_behave_like 'has a values clause'

  it "should have a table option" do
    @sql.table :users
    @sql.instance_variable_get('@table').should == :users
  end
end
