# -*- encoding: utf-8 -*-
require File.expand_path('../lib/peek_a_view/version', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "peek-a-view"
  gem.version     = PeekAView::VERSION
  gem.authors     = ["Michael Schuerig"]
  gem.email       = ["michael@schuerig.de"]
  gem.homepage    = ""
  gem.summary     = "Look at your Rails views without bothering the application"
  gem.description = "Show views using stubbed data."
  gem.license     = 'MIT'

  gem.files      = `git ls-files`.split($\)
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_runtime_dependency "rails", "~> 3.2.6"
end
