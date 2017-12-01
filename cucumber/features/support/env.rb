require "run_loop"
require "rspec"

require "calabash-cucumber/wait_helpers"
World(Calabash::Cucumber::WaitHelpers)

# Pry is not allowed on the Xamarin Test Cloud.  This will force a validation
# error if you mistakenly submit a binding.pry to the Test Cloud.
if !RunLoop::Environment.xtc?
  require "pry"
  Pry.config.history.file = ".pry-history"
  require "pry-nav"

  require "pry/config"
  class Pry
    trap("INT") { exit!(1) }
  end
end
