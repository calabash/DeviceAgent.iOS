module DeviceAgent
  class Gestures
    require "run_loop"
    attr_accessor :waiter

    def initialize(waiter)
      @waiter = waiter
    end

    def query_for_coordinate(mark)
      result = waiter.wait_for_view(mark)
      element_center(result)
    end

    def tap_mark(mark)
      center = query_for_coordinate(mark)
      tap(center[:x], center[:y])
    end

    def tap(x, y)
      device_agent.perform_coordinate_gesture("touch", x, y)
    end

    def double_tap_mark(mark)
      center = query_for_coordinate(mark)
      double_tap(center[:x], center[:y])
    end

    def double_tap(x, y)
      device_agent.perform_coordinate_gesture("double_tap", x, y)
    end

    def two_finger_tap_mark(mark)
      center = query_for_coordinate(mark)
      two_finger_tap(center[:x], center[:y])
    end

    def two_finger_tap(x, y)
      device_agent.perform_coordinate_gesture("two_finger_tap", x, y)
    end

    private

    def device_agent
      @waiter.device_agent
    end

    def element_center(hash)
      rect = hash["rect"]
      h = rect["height"]
      w = rect["width"]
      x = rect["x"]
      y = rect["y"]

      touchx = x + ((w/2.0).round(2))
      touchy = y + ((h/2.0).round(2))

      new_rect = rect.dup
      new_rect[:center_x] = touchx
      new_rect[:center_y] = touchy

      RunLoop.log_debug(%Q[Rect from query:

#{JSON.pretty_generate(new_rect)}

])
			{:x => touchx, :y => touchy}
    end
  end
end

