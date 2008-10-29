require 'ronin/code/sql/fields_clause'

require 'helpers/code'

shared_examples_for "has a fields clause" do
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
