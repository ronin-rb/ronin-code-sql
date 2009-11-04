require 'ronin/code/sql/values_clause'

require 'spec_helper'
require 'code/sql/helpers/sql'

shared_examples_for "has a values clause" do
  include Helpers

  it "should have a values clause" do
    values = [1,'bob','secret']

    @sql.values(*values)

    should_have_clause(@sql,:values) do |clause|
      clause.values.should == values
    end
  end
end
