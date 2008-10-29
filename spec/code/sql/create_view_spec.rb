require 'ronin/code/sql/create_view'

require 'code/sql/create_examples'

describe CreateView do
  before(:each) do
    @sql = CreateView.new(common_dialect)
  end

  it_should_behave_like "Create"

  it "should have a view option" do
    @sql.view :users
    @sql.instance_variable_get('@name').should == :users
  end
end
