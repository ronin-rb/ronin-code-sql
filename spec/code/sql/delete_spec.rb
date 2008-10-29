require 'ronin/code/sql/delete'

require 'helpers/code'
require 'code/sql/has_from_clause_examples'
require 'code/sql/has_where_clause_examples'

describe Delete do
  before(:each) do
    @sql = Delete.new(common_dialect)
  end

  it_should_behave_like "has a from clause"
  it_should_behave_like "has a where clause"
end
