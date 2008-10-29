require 'ronin/code/sql/drop_view'

require 'code/sql/drop_examples'

describe DropView do
  before(:each) do
    @sql = DropView.new(common_dialect)
  end

  it_should_behave_like "Drop"

  it "should have a table option" do
    @sql.view :users
    @sql.instance_variable_get('@name').should == :users
  end
end
