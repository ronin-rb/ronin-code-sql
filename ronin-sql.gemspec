# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ronin-sql}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Postmodern"]
  s.date = %q{2010-08-24}
  s.default_executable = %q{ronin-sql}
  s.description = %q{Ronin SQL is a Ruby library for Ronin that provids support for SQL related security tasks.}
  s.email = %q{postmodern.mod3@gmail.com}
  s.executables = ["ronin-sql"]
  s.extra_rdoc_files = [
    "ChangeLog.md",
    "README.md"
  ]
  s.files = [
    ".gitignore",
    ".rspec",
    ".yardopts",
    "COPYING.txt",
    "ChangeLog.md",
    "Gemfile",
    "Gemfile.lock",
    "README.md",
    "Rakefile",
    "bin/ronin-sql",
    "lib/ronin/code/sql.rb",
    "lib/ronin/code/sql/code.rb",
    "lib/ronin/code/sql/encoder.rb",
    "lib/ronin/code/sql/factory.rb",
    "lib/ronin/code/sql/fragment.rb",
    "lib/ronin/code/sql/function.rb",
    "lib/ronin/code/sql/style.rb",
    "lib/ronin/exploits/helpers/sqli.rb",
    "lib/ronin/exploits/sqli.rb",
    "lib/ronin/formatting/extensions/sql.rb",
    "lib/ronin/formatting/extensions/sql/string.rb",
    "lib/ronin/formatting/sql.rb",
    "lib/ronin/sql.rb",
    "lib/ronin/sql/error.rb",
    "lib/ronin/sql/error/error.rb",
    "lib/ronin/sql/error/extensions.rb",
    "lib/ronin/sql/error/extensions/string.rb",
    "lib/ronin/sql/error/message.rb",
    "lib/ronin/sql/error/pattern.rb",
    "lib/ronin/sql/error/patterns.rb",
    "lib/ronin/sql/extensions.rb",
    "lib/ronin/sql/extensions/uri.rb",
    "lib/ronin/sql/extensions/uri/http.rb",
    "lib/ronin/sql/injection.rb",
    "lib/ronin/sql/scanner.rb",
    "lib/ronin/sql/version.rb",
    "ronin-sql.gemspec",
    "spec/code/sql/classes/test_encoder.rb",
    "spec/code/sql/encoder_spec.rb",
    "spec/code/sql/factory_spec.rb",
    "spec/code/sql/fragment_spec.rb",
    "spec/code/sql/function_spec.rb",
    "spec/exploits/sqli_spec.rb",
    "spec/formatting/sql/string_spec.rb",
    "spec/helpers/database.rb",
    "spec/spec_helper.rb",
    "spec/sql/error_spec.rb",
    "spec/sql/extensions/uri/http_spec.rb",
    "spec/sql_spec.rb"
  ]
  s.has_rdoc = %q{yard}
  s.homepage = %q{http://github.com/ronin-ruby/ronin-sql}
  s.licenses = ["GPL-2"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Ruby library for Ronin that provids support for SQL related security tasks.}
  s.test_files = [
    "spec/code/sql/classes/test_encoder.rb",
    "spec/code/sql/encoder_spec.rb",
    "spec/code/sql/factory_spec.rb",
    "spec/code/sql/fragment_spec.rb",
    "spec/code/sql/function_spec.rb",
    "spec/exploits/sqli_spec.rb",
    "spec/formatting/sql/string_spec.rb",
    "spec/helpers/database.rb",
    "spec/spec_helper.rb",
    "spec/sql/error_spec.rb",
    "spec/sql/extensions/uri/http_spec.rb",
    "spec/sql_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ronin-support>, ["~> 0.1.0"])
      s.add_runtime_dependency(%q<ronin-web>, ["~> 0.2.2"])
      s.add_runtime_dependency(%q<ronin-gen>, ["~> 0.3.0"])
      s.add_runtime_dependency(%q<ronin-exploits>, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<ronin>, ["~> 0.4.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0.beta.20"])
    else
      s.add_dependency(%q<ronin-support>, ["~> 0.1.0"])
      s.add_dependency(%q<ronin-web>, ["~> 0.2.2"])
      s.add_dependency(%q<ronin-gen>, ["~> 0.3.0"])
      s.add_dependency(%q<ronin-exploits>, ["~> 0.4.0"])
      s.add_dependency(%q<ronin>, ["~> 0.4.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.0"])
      s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.20"])
    end
  else
    s.add_dependency(%q<ronin-support>, ["~> 0.1.0"])
    s.add_dependency(%q<ronin-web>, ["~> 0.2.2"])
    s.add_dependency(%q<ronin-gen>, ["~> 0.3.0"])
    s.add_dependency(%q<ronin-exploits>, ["~> 0.4.0"])
    s.add_dependency(%q<ronin>, ["~> 0.4.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.0"])
    s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.20"])
  end
end

