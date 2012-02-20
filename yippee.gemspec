# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pump/version"

Gem::Specification.new do |s|
  s.name        = "pump"
  s.version     = Pump::VERSION
  s.authors     = ["Dmitriy Vorotilin"]
  s.email       = ["d.vorotilin@gmail.com"]
  s.homepage    = "https://github.com/evrone/pump"
  s.summary     = "Ruby Rack server for developers"
  s.description = "Zero-configuration Rack server written on pure ruby"

  s.rubyforge_project = "pump"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
