require 'ronin/code/sql/create_index'

require 'code/sql/create_examples'

describe CreateIndex do
  before(:each) do
    @sql = CreateIndex.new(common_dialect)
  end

  it_should_behave_like "Create"

  it "should have an on clause" do
    @sql.on :users, [:name]

    @sql.has_clause?(:on).should == true

    on = @sql.get_clause(:on)
    on.table.should == :users
    on.fields.should == [:name]
  end

  it "should have an index option" do
    @sql.index :users
    @sql.instance_variable_get('@name').should == :users
  end
end
