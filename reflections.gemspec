# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reflections/version'

Gem::Specification.new do |spec|
  spec.name          = 'reflections'
  spec.version       = Reflections::VERSION
  spec.authors       = ['Benjamin Cavileer']
  spec.email         = ['bcavileer@holmanauto.com']
  spec.description   = %q{ActiveRecord::Base Reflections}
  spec.summary       = %q{Will help our project}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
end
