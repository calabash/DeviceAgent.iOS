module DeviceAgent
  class Wait

    require "run_loop"
    attr_accessor :device_agent

    def initialize(device_agent)
      @device_agent = device_agent
    end

    DEFAULTS = {
        timeout: RunLoop::Environment.ci? ? 16 : 8,
        retry_frequency: 0.1,
        # The default is to only return visible (hitable) views
        all: false,
        exception_class: Timeout::Error
     }

    def wait_for_animations
      sleep(0.5)
    end

    def wait_for(timeout_message, options={}, &block)
      wait_options = DEFAULTS.merge(options)
      timeout = wait_options[:timeout]

      exception_class = wait_options[:exception_class]
      with_timeout(timeout, timeout_message, exception_class) do
        loop do
          value = block.call

          return value if value

          sleep(wait_options[:retry_frequency])
        end
      end
    end

    def wait_for_keyboard
      timeout = DEFAULTS[:timeout]

      message = %Q[Timed out after #{timeout} seconds waiting for the keyboard to appear.]

      wait_for(message, DEFAULTS) do
        device_agent.keyboard_visible?
      end
    end

    def wait_for_alert
      timeout = DEFAULTS[:timeout]

      message = %Q[Timed out after #{timeout} seconds waiting for an alert to appear.]

      wait_for(message, DEFAULTS) do
        device_agent.alert_visible?
      end
    end

    def wait_for_no_alert
      timeout = DEFAULTS[:timeout]

      message = %Q[Timed out after #{timeout} seconds waiting for an alert to disappear.]

      if RunLoop::Environment.ci?
        delay = 2.0
      else
        delay = 1.0
      end
      sleep(delay)

      wait_for(message, DEFAULTS) do
        !device_agent.alert_visible?
      end
    end

    def wait_for_text_in_view(text, mark)
      result = wait_for_view(mark)

      candidates = [result["value"],
                    result["label"]]
      match = candidates.any? do |elm|
        elm == text
      end
      if !match
        fail(%Q[
Expected to find '#{text}' as a 'value' or 'label' in

#{JSON.pretty_generate(result)}

])
      end
    end

    def wait_for_view(mark, options={})
      default_options = DEFAULTS.dup
      merged_options = default_options.merge(options)

      unless merged_options[:message]
        message = %Q[Waited #{merged_options[:timeout]} seconds for

query("#{mark}", {all: #{merged_options[:all]}})

to match a view.

]
        merged_options[:timeout_message] = message
      end

      result = nil
      wait_for(merged_options[:timeout_message], options) do
        result = device_agent.query(mark, merged_options)
        !result.empty?
      end

      result[0]
    end

    def wait_for_no_view(mark, options={})
      default_options = DEFAULTS.dup
      merged_options = default_options.merge(options)

      unless merged_options[:message]
        message = %Q[Waited #{merged_options[:timeout]} seconds for

query("#{mark}", {all: #{merged_options[:all]}})

to match no views.

]
        merged_options[:timeout_message] = message
      end


      result = nil
      wait_for(merged_options[:timeout_message], options) do
        result = device_agent.query(mark, merged_options)
        result.empty?
      end

      result[0]
    end

    # @!visibility private
    class PrivateWaitTimeoutError < RuntimeError ; end

    def with_timeout(timeout, timeout_message, exception_class = Timeout::Error, &block)
      if timeout_message.nil? ||
          (timeout_message.is_a?(String) && timeout_message.empty?)
        raise ArgumentError, 'You must provide a timeout message'
      end

      unless block_given?
        raise ArgumentError, 'You must provide a block'
      end

      # Timeout.timeout will never timeout if the given `timeout` is zero.
      # We will raise an exception if the timeout is zero.
      # Timeout.timeout already raises an exception if `timeout` is negative.
      if timeout == 0
        raise ArgumentError, 'Timeout cannot be 0'
      end

      message = if timeout_message.is_a?(Proc)
                  timeout_message.call({timeout: timeout})
                else
                  timeout_message
                end

      failed = false

      begin
        Timeout.timeout(timeout, PrivateWaitTimeoutError) do
          return block.call
        end
      rescue PrivateWaitTimeoutError => _
        # If we raise Timeout here the stack trace will be cluttered and we
        # wish to show the user a clear message, avoiding
        # "`rescue in with_timeout':" in the stack trace.
        failed = true
      end

      if failed
        fail(message)
      end
    end

    def fail(*several_variants)
      arg0 = several_variants[0]
      arg1 = several_variants[1]

      if arg1.nil?
        exception_type = RuntimeError
        message = arg0
      else
        exception_type = arg0
        message = arg1
      end

      raise exception_type, message
    end
  end
end

