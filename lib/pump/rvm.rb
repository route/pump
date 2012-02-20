if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  rvm_path     = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
  rvm_lib_path = File.join(rvm_path, 'lib')
  $LOAD_PATH.unshift rvm_lib_path
  require 'rvm' rescue LoadError
end
