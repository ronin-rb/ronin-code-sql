require 'spec_helper'

require 'ronin/code/sql/common_dialect'

include Code::SQL

def common_dialect
  Dialect.get(:common).new
end

def should_have_clause(sql,name,&block)
  sql.has_clause?(name).should == true
  block.call(sql.get_clause(name)) if block
end
