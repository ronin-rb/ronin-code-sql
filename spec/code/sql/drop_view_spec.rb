require 'ronin/code/sql/drop_view'

require 'spec_helper'
require 'code/sql/helpers/sql'
require 'code/sql/drop_examples'

describe Code::SQL::DropView do
  include Helpers

  before(:each) do
    @sql = Code::SQL::DropView.new(common_dialect)
  end

  it_should_behave_like "Drop"

  it "should have a table option" do
    @sql.view :users
    @sql.instance_variable_get('@name').should == :users
  end
end
