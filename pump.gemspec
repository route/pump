lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pump/version'

Gem::Specification.new do |gem|
  gem.name        = 'pump'
  gem.version     = Pump::VERSION
  gem.authors     = 'Dmitry Vorotilin'
  gem.email       = 'd.vorotilin@gmail.com'
  gem.description = 'Zero-configuration rack server for multiple applications running simultaneously'
  gem.summary     = 'Zero-configuration rack server written on pure ruby'
  gem.homepage    = 'https://github.com/route/pump'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'puma'
  gem.add_runtime_dependency 'masquito'
  gem.add_runtime_dependency 'activesupport'
end
