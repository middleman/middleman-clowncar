# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-clowncar/version"

Gem::Specification.new do |s|
  s.name        = "middleman-clowncar"
  s.version     = Middleman::ClownCar::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Reynolds"]
  s.email       = ["me@tdreyno.com"]
  s.homepage    = "https://github.com/middleman/middleman-clowncar"
  s.summary     = %q{Adds ClownCar to Middleman}
  s.description = %q{Adds ClownCar to Middleman}

  s.rubyforge_project = "middleman-clowncar"

  s.files         = `git ls-files -z`.split("\0")
  s.test_files    = `git ls-files -z -- {fixtures,features}/*`.split("\0")
  s.require_paths = ["lib"]
  
  s.add_dependency("middleman-core", [">= 3.1.5"])
end
