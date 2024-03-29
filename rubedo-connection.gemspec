# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubedo/connection/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubedo-connection'
  spec.version       = Rubedo::Connection::VERSION::String
  spec.authors       = ['Andrey Savchenko']
  spec.email         = %w(andrey@aejis.eu)
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'connection_pool', '~> 2.0'
  spec.add_dependency 'adamantium'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'thor',    '~> 0.19'
end
