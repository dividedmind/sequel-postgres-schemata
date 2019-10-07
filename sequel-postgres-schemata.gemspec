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

  spec.add_runtime_dependency "sequel"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "pg", "~> 0.16"
end
