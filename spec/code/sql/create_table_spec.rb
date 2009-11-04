require 'ronin/code/sql/create_table'
require 'ronin/code/sql/program'

require 'spec_helper'
require 'code/sql/helpers/sql'
require 'code/sql/create_examples'

describe Code::SQL::CreateTable do
  include Helpers

  before(:each) do
    @sql = Code::SQL::CreateTable.new(common_dialect)
  end

  it_should_behave_like "Create"

  it "should have a columns clause" do
    columns = [:id, :name, :users]

    @sql.columns(*columns)

    should_have_clause(@sql,:columns) do |clause|
      clause.fields.should == columns
    end
  end

  it "should have a table option" do
    @sql.table :users
    @sql.instance_variable_get('@name').should == :users
  end
end
