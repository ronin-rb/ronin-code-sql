require 'ronin/code/sql/create_index'

require 'spec_helper'
require 'code/sql/helpers/sql'
require 'code/sql/create_examples'

describe Code::SQL::CreateIndex do
  include Helpers

  before(:each) do
    @sql = Code::SQL::CreateIndex.new(common_dialect)
  end

  it_should_behave_like "Create"

  it "should have an on clause" do
    @sql.on :users, [:name]

    should_have_clause(@sql,:on) do |on|
      on.table.should == :users
      on.fields.should == [:name]
    end
  end

  it "should have an index option" do
    @sql.index :users
    @sql.instance_variable_get('@name').should == :users
  end
end
