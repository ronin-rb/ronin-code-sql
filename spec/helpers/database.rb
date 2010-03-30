require 'ronin/database'
require 'ronin/exploits/sqli'

require 'spec_helper'

module Helpers
  Database.repositories[:default] = 'sqlite3::memory:'

  Database.setup
end
