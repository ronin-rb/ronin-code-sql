require 'ronin/code/sql/create_view'

require 'spec_helper'
require 'code/sql/helpers/sql'
require 'code/sql/create_examples'

describe Code::SQL::CreateView do
  include Helpers

  before(:each) do
    @sql = Code::SQL::CreateView.new(common_dialect)
  end

  it_should_behave_like "Create"

  it "should have a view option" do
    @sql.view :users
    @sql.instance_variable_get('@name').should == :users
  end
end
