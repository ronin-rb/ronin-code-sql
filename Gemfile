source 'https://rubygems.org'

RONIN = 'git://github.com/ronin-ruby'

group(:runtime) do
  gem 'ronin-support',	'~> 0.1.0', :git => "#{RONIN}/ronin-support.git"
  gem 'ronin-web',	'~> 0.2.2', :git => "#{RONIN}/ronin-web.git"
  gem 'ronin-gen',	'~> 0.3.0', :git => "#{RONIN}/ronin-gen.git"
  gem 'ronin-exploits',	'~> 0.4.0', :git => "#{RONIN}/ronin-exploits.git"
  gem 'ronin',		'~> 0.4.0', :git => "#{RONIN}/ronin.git"
end

group(:development) do
  gem 'bundler',	'~> 1.0.0'
  gem 'rake',		'~> 0.8.7'
  gem 'jeweler',	'~> 1.4.0', :git => 'git://github.com/technicalpickles/jeweler.git'
end

group(:doc) do
  case RUBY_PLATFORM
  when 'java'
    gem 'maruku',	'~> 0.6.0'
  else
    gem 'rdiscount',	'~> 1.6.3'
  end

  gem 'yard',		'~> 0.5.3'
end

gem 'rspec',	'~> 2.0.0.beta.16', :group => [:development, :test]
