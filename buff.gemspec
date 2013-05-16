# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buff/version'

Gem::Specification.new do |gem|
  gem.name          = "buff"
  gem.version       = Buff::VERSION
  gem.authors       = ["ZPH"]
  gem.email         = ["Zander@civet.ws"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'rb-fsevent'
  gem.add_development_dependency 'growl'
  gem.add_development_dependency 'pry-full'
  gem.add_development_dependency 'rake'

  gem.add_runtime_dependency 'multi_json'
  gem.add_runtime_dependency 'yajl-ruby'
  # gem.add_runtime_dependency 'faraday_middleware'
  gem.add_runtime_dependency 'httparty'
  gem.add_runtime_dependency 'rash'
end
