# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'hoe/signing'
require './tasks/spec.rb'

Hoe.spec('ronin-sql') do
  self.rubyforge_name = 'ronin'
  self.developer('Postmodern','postmodern.mod3@gmail.com')
  self.remote_rdoc_dir = 'docs/ronin-sql'
  self.extra_deps = [
    ['ronin', '>=0.2.4'],
    ['ronin-web', '>=0.1.3']
  ]

  self.extra_dev_deps = [
    ['rspec', '>=1.1.12'],
    ['yard', '>=0.2.3.5']
  ]
end

# vim: syntax=Ruby
