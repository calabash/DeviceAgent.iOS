module DeviceAgent
  class Wait
    attr_accessor :device_agent

    def initialize(device_agent)
      @device_agent = device_agent
    end

    DEFAULTS = {
        timeout: ENV["XAMARIN_TEST_CLOUD"] ? 24 : 8,
        retry_frequency: 0.1,
        # The default is to only return visible (hitable) views
        all: false,
        exception_class: Timeout::Error
     }
  end
end

