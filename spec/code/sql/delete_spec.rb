require 'ronin/code/sql/delete'

require 'spec_helper'
require 'code/sql/helpers/sql'
require 'code/sql/has_from_clause_examples'
require 'code/sql/has_where_clause_examples'

describe Code::SQL::Delete do
  include Helpers

  before(:each) do
    @sql = Code::SQL::Delete.new(common_dialect)
  end

  it_should_behave_like "has a from clause"
  it_should_behave_like "has a where clause"
end
