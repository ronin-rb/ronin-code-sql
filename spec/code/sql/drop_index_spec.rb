require 'ronin/code/sql/drop_index'

require 'code/sql/drop_examples'

describe DropIndex do
  before(:each) do
    @sql = DropIndex.new(common_dialect)
  end

  it_should_behave_like "Drop"

  it "should have a table option" do
    @sql.index :users
    @sql.instance_variable_get('@name').should == :users
  end
end
