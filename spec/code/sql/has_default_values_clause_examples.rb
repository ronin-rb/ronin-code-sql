require 'ronin/code/sql/default_values_clause'

require 'helpers/code'

shared_examples_for "has a default values clause" do
  it "should have a default values clause" do
    @sql.default_values
    @sql.has_clause?(:default_values).should == true
  end
end
