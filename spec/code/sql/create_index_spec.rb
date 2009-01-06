require 'ronin/code/sql/create_index'

require 'code/sql/create_examples'

describe CreateIndex do
  before(:each) do
    @sql = CreateIndex.new(common_dialect)
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
