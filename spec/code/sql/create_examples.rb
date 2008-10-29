require 'ronin/code/sql/create'

require 'helpers/code'

shared_examples_for "Create" do
  it "should have a fields clause" do
    @sql.fields :id, :name, :users

    @sql.has_clause?(:fields).should == true
    @sql.get_clause(:fields).fields.should == [
      :id,
      :name,
      :users
    ]
  end
end
