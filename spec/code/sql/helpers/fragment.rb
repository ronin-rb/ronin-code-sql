require 'ronin/code/sql/fragment'

module Helpers
  module Fragment
    def sql(options={})
      Code::SQL::Fragment.new([],options)
    end
  end
end
