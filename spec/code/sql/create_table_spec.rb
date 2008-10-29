require 'ronin/code/sql/create_table'
require 'ronin/code/sql/program'

require 'code/sql/create_examples'

describe CreateTable do
  before(:each) do
    @sql = CreateTable.new(common_dialect)
  end

  it_should_behave_like "Create"

  it "should have a columns clause" do
    @sql.columns :id, :name, :users

    @sql.has_clause?(:columns).should == true
    @sql.get_clause(:columns).fields.should == [
      :id,
      :name,
      :users
    ]
  end
end
