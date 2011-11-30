# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yippee/version"

Gem::Specification.new do |s|
  s.name        = "yippee"
  s.version     = Yippee::VERSION
  s.authors     = ["Andrey Ognevsky"]
  s.email       = ["a.ognevsky@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Pow-like app for pure-Ruby lovers}
  s.description = %q{Pow-like app for pure-Ruby lovers}

  s.rubyforge_project = "yippee"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rubydns"
end
