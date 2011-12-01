# Let's change privileges if we have not them
def sudome
  if ENV["USER"] != "root"
    exec("sudo #{ENV['_']} #{ARGV.join(' ')}")
  end
end

# Running up!
sudome
