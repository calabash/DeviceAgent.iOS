
module TestApp
  module Pan

    def clear_pan_action_label
      @gestures.touch_mark("pan action")
      wait_for_pan_action_text("CLEARED")
    end

    def wait_for_pan_action_text(text)
      @waiter.wait_for_text_in_view(text, "pan action")
    end

    def top_midpoint_for_scrolling(mark)
      rect = @gestures.query_for_rect(mark)
      x = rect["width"]/2.0

      mid_y = rect["height"]/2.0
      y = mid_y - (mid_y/2.0)
      {x: x, y: y}
    end

    def bottom_midpoint_for_scrolling(mark)
      rect = @gestures.query_for_rect(mark)
      x = rect["width"]/2.0

      mid_y = rect["height"]/2.0
      y = mid_y + (mid_y/2.0)
      {x: x, y: y}
    end

    def hit_point_same_as_element_center(hit_point, element_center, delta=4)
      x_diff = (hit_point["x"].to_i - element_center[:x].to_i).abs.to_i
      y_diff = (hit_point["y"].to_i - element_center[:y].to_i).abs.to_i
      x_diff.between?(0, delta) && y_diff.between?(0, delta)
    end

    def scroll_to(direction, scroll_view_mark, view_mark, times)
      options = {
        :duration => 0.5
      }

      if direction == :down
        from_point = bottom_midpoint_for_scrolling(scroll_view_mark)
        to_point = top_midpoint_for_scrolling(scroll_view_mark)
      else
        from_point = top_midpoint_for_scrolling(scroll_view_mark)
        to_point = bottom_midpoint_for_scrolling(scroll_view_mark)
      end

      found = false

      times.times do
        @gestures.pan_between_coordinates(from_point, to_point, options)
        sleep(0.5)

        view = @gestures.query(view_mark).first
        if view
          hit_point = view["hit_point"]
          element_center = @gestures.send(:element_center, view)
          found = hit_point_same_as_element_center(hit_point, element_center)
        end

        break if found
      end

      if !found
        fail(%Q[
Scrolled down on '#{scroll_view_mark}' #{times} times,
but did not see '#{view_mark}'
])
      end
    end

    def scroll_down_to(scroll_view_mark, view_mark, times)
      scroll_to(:down, scroll_view_mark, view_mark, times)
    end

    def scroll_up_to(scroll_view_mark, view_mark, times)
      scroll_to(:up, scroll_view_mark, view_mark, times)
    end
  end
end

World(TestApp::Pan)

And(/^I am looking at the Pan Palette page$/) do
  @waiter.wait_for_view("pan page")
  @gestures.touch_mark("pan palette row")
  @waiter.wait_for_view("pan palette page")
  @waiter.wait_for_animations
end

Given(/^I am looking at the Drag and Drop page$/) do
  @gestures.tap_mark("table row")
  @waiter.wait_for_view("table page")
  @waiter.wait_for_animations
end

Given(/^I am looking at the Everything's On the Table page$/) do
  @gestures.tap_mark("table row")
  @waiter.wait_for_view("table page")
  @waiter.wait_for_animations
end

And(/^I can pan with (\d+) fingers?$/) do |fingers|
  clear_pan_action_label

  options = {
    :num_fingers => fingers.to_i,
    :duration => 0.5
  }

  if fingers.to_i > 3
    from_point = {:x => 160, :y => 80}
    to_point = {:x => 160, :y => 460}
  else
    from_point = {:x => 20, :y => 80}
    to_point = {:x => 300, :y => 460}
  end

  @gestures.pan_between_coordinates(from_point, to_point, options)

  wait_for_pan_action_text("Pan")
end

But(/^I cannot pan with 6 fingers$/) do
  options = {
    :num_fingers => 6,
    :duration => 0.5
  }

  from_point = {:x => 20, :y => 80}
  to_point = {:x => 300, :y => 460}

  expect do
    @gestures.pan_between_coordinates(from_point, to_point, options)
  end.to raise_error RunLoop::XCUITest::HTTPError,
                     /num_fingers must be between 1 and 5, inclusive/
end

And(/^I can pan (quickly|slowly)$/) do |speed|
  clear_pan_action_label

  if speed == "quickly"
    duration = 0.1
  else
    duration = 1.0
  end

  options = {
    :duration => duration
  }

  from_point = {:x => 160, :y => 80}
  to_point = {:x => 160, :y => 460}
  @gestures.pan_between_coordinates(from_point, to_point, options)

  wait_for_pan_action_text("Pan")
end

Then(/^I can drag the red box to the right well$/) do
  # TODO Figure out how to query for these elements so we can test in other
  # orientations and form factors.
  @gestures.rotate_home_button_to(:bottom)

  from_point = {:x => 83.5, :y => 124}
  to_point = {:x => 105.5, :y => 333.5}
  @gestures.pan_between_coordinates(from_point, to_point)

  # TODO figure out how to assert the drag and drop happened.
end


Then(/^I can scroll down to the Windows row$/) do
  scroll_view_mark = "table page"
  view_mark = "windows row"
  scroll_down_to(scroll_view_mark, view_mark, 5)

end

And(/^then back up to the Apple row$/) do
  scroll_view_mark = "table page"
  view_mark = "apple row"
  scroll_up_to(scroll_view_mark, view_mark, 5)
end
