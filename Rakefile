# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/spec.rb'
require './lib/ronin/sql/version.rb'

Hoe.spec('ronin-sql') do |p|
  p.rubyforge_name = 'ronin'
  p.developer('Postmodern','postmodern.mod3@gmail.com')
  p.remote_rdoc_dir = 'docs/ronin-sql'
  p.extra_deps = [
    ['ronin', '>=0.2.2'],
    ['ronin-web', '>=0.1.0']
  ]
end

# vim: syntax=Ruby
