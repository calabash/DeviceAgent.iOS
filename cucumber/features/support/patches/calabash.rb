
begin
  module Calabash
    module Cucumber
      module WaitHelpers
        def wait_for(options_or_timeout=DEFAULT_OPTS, &block)
          if options_or_timeout.is_a?(Hash)
            timeout = options_or_timeout[:timeout]
            message = options_or_timeout[:timeout_message] ||
              "Waiting for something to happen with timeout: #{timeout}"
            options = options_or_timeout.dup
          else
            timeout = options_or_timeout
            message = "Waiting for something to happen with timeout: #{timeout}"
            options = {:timeout => timeout}
          end
          Class.new do
            require File.expand_path(File.join(__FILE__, "..", "automator.rb"))
            include DeviceAgent::Automator
            def to_s; "#<Anon DeviceAgent::Automator>"; end
            def inspect; to_s; end
          end.new.wait_for(message, options, &block)
        end
      end
    end
  end
rescue => e
  $stdout.puts "error in calabash patch: #{e}"
end
