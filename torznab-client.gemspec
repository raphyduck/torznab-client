# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'torznab/version'

Gem::Specification.new do |spec|
  spec.name          = "torznab-client"
  spec.version       = Torznab::VERSION
  spec.authors       = ["Nicolas MERELLI"]
  spec.email         = ["nicolas.merelli@gmail.com"]

  spec.summary       = "Ruby client for Torznab APIs. "
  spec.description   = "Ruby client for Torznab APIs (like Jackett)."
  spec.homepage      = "https://github.com/PNSalocin/torznab-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '~> 1.8'
  spec.add_dependency 'mechanize'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  # CI
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "yard"

  # Tests
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "simplecov"
end
