require 'ronin/code/sql/update'

require 'spec_helper'
require 'code/sql/helpers/sql'
require 'code/sql/has_where_clause_examples'

describe Code::SQL::Update do
  include Helpers

  before(:each) do
    @sql = Code::SQL::Update.new(common_dialect)
  end

  it_should_behave_like "has a where clause"

  it "should have a set clause" do
    values = [1, 'bob', 25]
    @sql.set(*values)

    should_have_clause(@sql,:set) do |clause|
      clause.values.should == values
    end
  end

  it "should have a table option" do
    @sql.table :users
    @sql.instance_variable_get('@table').should == :users
  end
end
