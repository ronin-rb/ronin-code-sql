source 'https://rubygems.org'

RONIN_URI  = 'http://github.com/ronin-ruby'

gemspec

gem 'jruby-openssl',	'~> 0.7', :platforms => :jruby

# Ronin dependencies:
# gem 'ronin-support',  '~> 0.6',   :git => "#{RONIN_URI}/ronin-support.git"
# gem 'ronin',          '~> 1.5.0', :git => "#{RONIN_URI}/ronin.git"

group :development do
  gem 'rake',         '~> 10.0'
  gem 'kramdown',     '~> 0.12'

  gem 'ripl',              '~> 0.3'
  gem 'ripl-multi_line',   '~> 0.2'
  gem 'ripl-auto_indent',  '~> 0.1'
  gem 'ripl-short_errors', '~> 0.1'
  gem 'ripl-color_result', '~> 0.3'

  gem 'rubygems-tasks', '~> 0.1'
  gem 'rspec',          '~> 2.4'
  gem 'simplecov',      '~> 0.7'
end
