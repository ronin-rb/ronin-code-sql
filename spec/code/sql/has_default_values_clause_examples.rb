require 'ronin/code/sql/default_values_clause'

require 'spec_helper'
require 'code/sql/helpers/sql'

shared_examples_for "has a default values clause" do
  include Helpers

  it "should have a default values clause" do
    @sql.default_values
    @sql.has_clause?(:default_values).should == true
  end
end
