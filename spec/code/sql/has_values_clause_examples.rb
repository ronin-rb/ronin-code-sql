require 'ronin/code/sql/values_clause'

require 'helpers/code'

shared_examples_for "has a values clause" do
  it "should have a values clause" do
    values = [1,'bob','secret']

    @sql.values values

    @sql.has_clause?(:values)
    @sql.get_clause(:values).values.should == values
  end
end
