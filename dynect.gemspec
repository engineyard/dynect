# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dynect/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Engine Yard"]
  gem.email         = ["engineering@engineyard.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dynect"
  gem.require_paths = ["lib"]
  gem.version       = Dynect::VERSION

  gem.add_dependency "cistern",            "~> 0.11"
  gem.add_dependency "ey-logger",          "~> 0.0"
  gem.add_dependency "faraday",            "~> 0.9"
  gem.add_dependency "faraday_middleware", "~> 0.9"
end
