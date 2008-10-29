require 'ronin/code/sql/from_clause'

require 'helpers/code'

shared_examples_for "has a from clause" do
  it "should have a from clause" do
    @sql.from :users

    @sql.has_clause?(:from).should == true
    @sql.get_clause(:from).table.should == :users
  end
end
