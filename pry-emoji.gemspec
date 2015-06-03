# -*- encoding: utf-8 -*-

require File.expand_path('../lib/pry-emoji/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'pry-emoji'
  gem.version       = PryEmoji::VERSION
  gem.author        = 'chaunce'
  gem.email         = 'chaunce.slc@gmail.com'
  gem.license       = 'MIT'
  gem.homepage      = 'https://github.com/chaunce/pry-emoji'
  gem.summary       = 'Clutter up your shell with some emoji.'
  gem.description   = "Clutter up your shell with some emoji.  Why not?  You already have all that pry crap mucking everything up."

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  # Dependencies
  gem.required_ruby_version = '>= 1.8.7'
  gem.add_runtime_dependency 'pry'
  gem.add_runtime_dependency 'gemoji'
end
