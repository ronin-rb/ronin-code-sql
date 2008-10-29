require 'ronin/code/sql/create'

require 'code/sql/has_fields_clause_examples'

require 'helpers/code'

shared_examples_for "Create" do
  it_should_behave_like "has a fields clause"

  it "should have a temp option" do
    @sql.temp
    @sql.instance_variable_get('@temp').should == true
  end

  it "should have a if_not_exists option" do
    @sql.if_not_exists
    @sql.instance_variable_get('@if_not_exists').should == true
  end
end
