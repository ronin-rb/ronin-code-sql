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

  it "should have a temp option" do
    @sql.temp
    @sql.instance_variable_get('@temp').should == true
  end

  it "should have a if_not_exists option" do
    @sql.if_not_exists
    @sql.instance_variable_get('@if_not_exists').should == true
  end
end
