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

    def touch_mark(mark, options={})
      center = query_for_coordinate(mark)
      tap(center[:x], center[:y], options)
    end

    alias_method :tap_mark, :touch_mark

    def touch(x, y, options={})
      device_agent.perform_coordinate_gesture("touch",
                                              x, y,
                                              options)
    end

    alias_method :tap, :touch

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

    def long_press_mark(mark, duration=1.0)
      center = query_for_coordinate(mark)
      long_press(center[:x], center[:y], duration)
    end

    def long_press(x, y, duration=1.0)
      device_agent.perform_coordinate_gesture("touch",
                                              x, y,
                                              {:duration => duration})
    end

    def keyboard_visible?
      device_agent.keyboard_visible?
    end

    def enter_text(string)
      device_agent.enter_text(string)
    end

    def delete_with_backspace_char
      device_agent.enter_text("\b")
    end

    def touch_keyboard_delete_key
      touch_mark("delete")
    end

    def change_volume(direction)
      device_agent.change_volume(direction)
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

