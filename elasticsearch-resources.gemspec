# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/resources/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticsearch-resources"
  spec.version       = Elasticsearch::Resources::VERSION
  spec.authors       = ["David Elner"]
  spec.email         = ["david@davidelner.com"]

  spec.summary       = %q{Access well-known Elasticsearch indexes like resources.}
  spec.description   = %q{Allows you to strongly-type ES types and query them more easily.}
  spec.homepage      = "http://davidelner.com"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "elasticsearch", "~> 5.0.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
