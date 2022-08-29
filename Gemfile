source 'https://rubygems.org'

gemspec

gem 'jruby-openssl',	'~> 0.7', platform: :jruby

# Library dependencies
gem 'ronin-support',	       '~> 1.0', github: "ronin-rb/ronin-support",
                                       branch: '1.0.0'
group :development do
  gem 'rake'
  gem 'rubygems-tasks', '~> 0.1'

  gem 'rspec',          '~> 3.0'

  gem 'kramdown',       '~> 2.3'
  gem 'redcarpet',      platform: :mri
  gem 'yard',           '~> 0.9'
end
