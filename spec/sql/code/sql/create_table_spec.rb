require 'ronin/code/sql/create_table'
require 'ronin/code/sql/program'

require 'code/sql/create_examples'

describe CreateTable do
  before(:each) do
    @sql = CreateTable.new(common_dialect)
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
