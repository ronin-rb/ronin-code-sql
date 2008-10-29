require 'ronin/code/sql/drop'

require 'helpers/code'

shared_examples_for "Drop" do
  it "should have an if_exists option" do
    @sql.if_exists
    @sql.instance_variable_get('@if_exists').should == true
  end
end
