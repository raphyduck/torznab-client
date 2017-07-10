# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'torznab/client/version'

Gem::Specification.new do |spec|
  spec.name          = "torznab-client"
  spec.version       = Torznab::Client::VERSION
  spec.authors       = ["Nicolas MERELLI"]
  spec.email         = ["nicolas.merelli@gmail.com"]

  spec.summary       = "Ruby client to Torznab APIs."
  spec.description   = "Ruby client to Torznab APIs."
  spec.homepage      = "https://github.com/PNSalocin/torznab-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = `git ls-files -- spec/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "yard"
end
