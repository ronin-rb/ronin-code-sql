require 'ronin/code/sql/delete'

require 'helpers/code'

describe Delete do
  before(:each) do
    @sql = Delete.new(common_dialect)
  end

  it "should have a where clause" do
    @sql.instance_eval do
      where name == 'bob'
    end

    @sql.has_clause?(:where).should == true
    @sql.get_clause(:where).expr.should_not be_nil
  end

  it "should have a from option" do
    @sql.from :users
    @sql.instance_variable_get('@table').should == :users
  end
end
