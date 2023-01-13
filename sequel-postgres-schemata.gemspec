# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel/postgres/schemata/version'

Gem::Specification.new do |spec|
  spec.name          = "sequel-postgres-schemata"
  spec.version       = Sequel::Postgres::Schemata::VERSION
  spec.authors       = ["Rafał Rzepecki"]
  spec.email         = ["rafal@conjur.net"]
  spec.description   = %q{Allows easy manipulation of Postgres schemas from Ruby with Sequel}
  spec.summary       = %q{Postgres schema manipulation}
  spec.homepage      = "https://github.com/dividedmind/sequel-postgres-schemata"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sequel", "~> 5.60.1"
  spec.add_runtime_dependency "bigdecimal", "~> 1.4.3"
  
  spec.add_development_dependency "bundler", "~> 2.2.33"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "pg", "~> 0.16"
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4.1'
end
