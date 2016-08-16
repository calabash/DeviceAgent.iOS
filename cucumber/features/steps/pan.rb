
module TestApp
  module Pan

    def clear_pan_action_label
      @gestures.touch_mark("pan action")
      wait_for_pan_action_text("CLEARED")
    end

    def wait_for_pan_action_text(text)
      @waiter.wait_for_text_in_view(text, "pan action")
    end

    def pan(direction, mark, duration, size, query_options={})
      merged_options = {
        :all => false,
        :specifier => :id
      }.merge(query_options)

      case size
        when :large
          from_point = point_for_full_pan_start(direction, mark, merged_options)
          to_point = point_for_full_pan_end(direction, mark, merged_options)
        when :medium
          from_point = point_for_medium_pan_start(direction, mark, merged_options)
          to_point = point_for_medium_pan_end(direction, mark, merged_options)
        when :small
         raise "NYI"
        else
          raise ArgumentError, "Expected '#{size}' to be :large, :medium, :small"
      end

      @gestures.pan_between_coordinates(from_point, to_point,
                                        {duration: duration})
    end

    def scroll(direction, mark, query_options={})
      merged_options = {
        :all => false,
        :specifier => :id
      }.merge(query_options)

      pan(direction, mark, 1.0, :medium, merged_options)
    end

    alias_method :swipe, :scroll

    def flick(direction, mark, query_options={})
      merged_options = {
        :all => false,
        :specifier => :id
      }.merge(query_options)

      pan(direction, mark, 0.1, :medium, merged_options)
    end

    def scroll_to(direction, scroll_view_mark, view_mark, times)
      return if !@gestures.query(view_mark).empty?

      found = false

      times.times do
        scroll(direction, scroll_view_mark)
        # Gesture takes 1.0 seconds
        sleep(1.5)

        view = @gestures.query(view_mark).first
        if view
          hit_point = view["hit_point"]
          element_center = @gestures.element_center(view)
          found = hit_point_same_as_element_center(hit_point, element_center)
        end

        break if found
      end

      if !found
        fail(%Q[
Scrolled :#{direction} on '#{scroll_view_mark}' #{times} times,
but did not see '#{view_mark}'
])
      end
    end

    def flick_to(direction, scroll_view_mark, view_mark, times)
      return if !@gestures.query(view_mark).empty?

      found = false

      times.times do
        flick(direction, scroll_view_mark)
        # Gesture takes 0.1 seconds
        sleep(1.0)

        view = @gestures.query(view_mark).first
        if view
          hit_point = view["hit_point"]
          element_center = @gestures.element_center(view)
          found = hit_point_same_as_element_center(hit_point, element_center)
        end

        break if found
      end

      if !found
        fail(%Q[
Flicked :#{direction} on '#{scroll_view_mark}' #{times} times,
but did not see '#{view_mark}'
])
      end
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
  @gestures.tap_mark("drag and drop row")
  @waiter.wait_for_view("drag and drop page")
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
  scroll_to(:up, scroll_view_mark, view_mark, 5)
  # TODO touch the row
end

And(/^then back up to the Apple row$/) do
  scroll_view_mark = "table page"
  view_mark = "apple row"
  scroll_to(:down, scroll_view_mark, view_mark, 5)
  # TODO touch the row
end

Given(/^I see the Apple row$/) do
  scroll_view_mark = "table page"
  view_mark = "apple row"

  if @gestures.query(view_mark).empty?
    scroll_to(:down, scroll_view_mark, view_mark, 5)
  end
end

Then(/^I can flick to the bottom of the Companies table$/) do
  scroll_view_mark = "table page"
  view_mark = "youtube row"
  flick_to(:up, scroll_view_mark, view_mark, 1)
end

Then(/^I can flick to the top of the Companies table$/) do
  scroll_view_mark = "table page"
  view_mark = "amazon row"
  flick_to(:down, scroll_view_mark, view_mark, 1)
end

And(/^I can swipe to delete the Windows row$/) do
  identifier = "windows row"
  @waiter.wait_for_view(identifier)

  swipe(:left, identifier)
  @gestures.touch_mark("Delete")

  @waiter.wait_for_no_view("Delete")
end

And(/^I have scrolled to the top of the Companies table$/) do
  element = @waiter.wait_for_view("StatusBar", {:all => true, :specifier => :type})
  center = @gestures.element_center(element)
  @gestures.touch(center[:x], center[:y])
  sleep(0.4)
end

When(/^I touch the Edit button, the table is in Edit mode$/) do
  @gestures.touch_mark("Edit")
  @waiter.wait_for_view("Done")
end

Then(/^I move the Android row above the Apple row$/) do
  android_element = @waiter.wait_for_view("Reorder Android")
  android_center = @gestures.element_center(android_element)
  apple_element = @waiter.wait_for_view("Reorder Apple")
  apple_center = @gestures.element_center(apple_element)

  from_point = {x: android_center[:x], y: android_center[:y]}
  to_point = {x: apple_center[:x], y: apple_center[:y]}
  @gestures.pan_between_coordinates(from_point, to_point)
  sleep(0.4)
  @gestures.touch_mark("Done")
end
