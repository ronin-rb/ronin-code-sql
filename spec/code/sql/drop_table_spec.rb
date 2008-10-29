require 'ronin/code/sql/drop_table'

require 'code/sql/drop_examples'

describe DropTable do
  before(:each) do
    @sql = DropTable.new(common_dialect)
  end

  it_should_behave_like "Drop"

  it "should have a table option" do
    @sql.table :users
    @sql.instance_variable_get('@name').should == :users
  end
end
