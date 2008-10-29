require 'ronin/code/sql/where_clause'

require 'helpers/code'

shared_examples_for "has a where clause" do
  it "should have a where clause" do
    @sql.instance_eval do
      where name == 'bob'
    end

    @sql.has_clause?(:where).should == true
    @sql.get_clause(:where).expr.should_not be_nil
  end
end
