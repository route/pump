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

  s.files         = Dir["bin/*", "config/*", "lib/**/*", "public/*", "var/**/.*", "Gemfile", "LICENSE", "Rakefile", "README.md", "pump.gemspec"]
  s.executables   = Dir["bin/*"].map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
