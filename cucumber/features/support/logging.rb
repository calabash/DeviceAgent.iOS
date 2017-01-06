module DeviceAgent
  module Logging
    def log_inline(message)
      require "run_loop"
      colored = RunLoop::Color.blue(message)
      $stdout.puts("    #{colored}")
      $stdout.flush
    end
  end
end

World(DeviceAgent::Logging)