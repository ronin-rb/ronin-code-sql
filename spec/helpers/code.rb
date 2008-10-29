require 'spec_helper'

require 'ronin/code/sql/common_dialect'

include Code::SQL

def common_dialect
  Dialect.get(:common).new
end
