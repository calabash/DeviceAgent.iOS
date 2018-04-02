
module TestApp
  module Coordinates

    # TODO The server seems to be able to return 2 of these query calls per
    # second.  The status_bar, tab_bar, nav_bar, and tool_bar heights will not
    # change in the context of single gesture, so these values can be fetched
    # once per gesture.

    def status_bar
      query({type: "StatusBar",  all: true}).first
    end

    def status_bar_height
      element = status_bar
      if element
        element["rect"]["height"]
      else
        0
      end
    end

    def tab_bar
      query({type: "TabBar", all: true}).first
    end

    def tab_bar_height
      element = status_bar
      if element
        # There is an invisible touch area above the tab bar.
        element["rect"]["height"] + 24
      else
        0
      end
    end

    def nav_bar
      query({type: "NavigationBar",  all: true}).first
    end

    def nav_bar_height
      element = nav_bar
      if element
        element["rect"]["height"]
      else
        0
      end
    end

    def tool_bar
      query({type: "ToolBar", all: true}).first
    end

    def tool_bar_height
      element = tool_bar
      if element
        element["rect"]["height"]
      else
        0
      end
    end

    # TODO there can be more than one window.
    def window
      query({type: "Window", all: true}).first
    end

    def window_size
      element = window
      {
        :width => element["rect"]["width"],
        :height => element["rect"]["height"]
      }
    end

    def left_full_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      {
        x: 10,
        y: element_center[:y]
      }
    end

    def right_full_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      {
        x: element["rect"]["x"] + element["rect"]["width"] - 10,
        y: element_center[:y]
      }
    end

    def top_full_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      if iphone_x?
        highest_possible = status_bar_height + nav_bar_height + 30
      else
        highest_possible = status_bar_height + nav_bar_height + 10
      end

      element_highest = element["rect"]["y"]
      {
        x: element_center[:x],
        y: [highest_possible, element_highest].max
      }
    end

    def bottom_full_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      lowest_possible = window_size[:height] - (tab_bar_height + tool_bar_height + 10)
      element_lowest = element["rect"]["y"] + element["rect"]["height"]
      {
        x: element_center[:x],
        y: [lowest_possible, element_lowest].min
      }
    end

    def point_for_full_pan_start(direction, uiquery, wait_options={})
      case direction
        when :left
          right_full_pan_point(uiquery, wait_options)
        when :right
          left_full_pan_point(uiquery, wait_options)
        when :up
          bottom_full_pan_point(uiquery, wait_options)
        when :down
          top_full_pan_point(uiquery, wait_options)
        else
          raise ArgumentError,
                "Direction #{direction} is not supported; use :left, :right, :top, :bottom"
      end
    end

    def point_for_full_pan_end(direction, uiquery, wait_options={})
      case direction
        when :left
          left_full_pan_point(uiquery, wait_options)
        when :right
          right_full_pan_point(uiquery, wait_options)
        when :up
          top_full_pan_point(uiquery, wait_options)
        when :down
          bottom_full_pan_point(uiquery, wait_options)
        else
          raise ArgumentError,
                "Direction #{direction} is not supported; use :left, :right, :top, :bottom"
      end
    end

    # Half-way between the middle of the view and the top of the view
    def top_medium_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      highest_possible = status_bar_height + nav_bar_height + 10
      element_top_mid = element_center[:y] - (element["rect"]["height"]/4.0)
      {
        x: element_center[:x],
        y: [highest_possible, element_top_mid].max
      }
    end

    # Half-way between the middle of the view and the bottom of the view
    def bottom_medium_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      lowest_possible = window_size[:height] - (tab_bar_height + tool_bar_height + 10)
      element_bottom_mid = element_center[:y] + (element["rect"]["height"]/4.0)
      {
        x: element_center[:x],
        y: [lowest_possible, element_bottom_mid].min
      }
    end

    # Half-way between the middle of the view and the left of the view
    def left_medium_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      lowest_possible = 10
      view_left_mid = element_center[:x] - (element["rect"]["width"]/4.0)

      {
        x: [lowest_possible, view_left_mid].max,
        y: element_center[:y]
      }
    end

    # Half-way between the middle of the view and the right side of the view
    def right_medium_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      highest_possible = window_size[:width] - 10
      view_right_mid = element_center[:x] + (element["rect"]["width"]/4.0)

      {
        x: [highest_possible, view_right_mid].min,
        y: element_center[:y]
      }
    end

    def point_for_medium_pan_start(direction, uiquery, wait_options={})
      case direction
        when :left
          right_medium_pan_point(uiquery, wait_options)
        when :right
          left_medium_pan_point(uiquery, wait_options)
        when :up
          bottom_medium_pan_point(uiquery, wait_options)
        when :down
          top_medium_pan_point(uiquery, wait_options)
        else
          raise ArgumentError,
                "Direction #{direction} is not supported; use :left, :right, :top, :bottom"
      end
    end

    def point_for_medium_pan_end(direction, uiquery, wait_options={})
      case direction
        when :left
          left_medium_pan_point(uiquery, wait_options)
        when :right
          right_medium_pan_point(uiquery, wait_options)
        when :up
          top_medium_pan_point(uiquery, wait_options)
        when :down
          bottom_medium_pan_point(uiquery, wait_options)
        else
          raise ArgumentError,
                "Direction #{direction} is not supported; use :left, :right, :top, :bottom"
      end
    end

    def top_small_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      highest_possible = status_bar_height + nav_bar_height + 10
      element_top_mid = element_center[:y] - (element["rect"]["height"]/6.0)
      {
        x: element_center[:x],
        y: [highest_possible, element_top_mid].max
      }
    end

    def bottom_small_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      lowest_possible = window_size[:height] - (tab_bar_height + tool_bar_height + 10)
      element_bottom_mid = element_center[:y] + (element["rect"]["height"]/6.0)
      {
        x: element_center[:x],
        y: [lowest_possible, element_bottom_mid].min
      }
    end

    # Half-way between the middle of the view and the left of the view
    def left_small_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      lowest_possible = 10
      view_left_mid = element_center[:x] - (element["rect"]["width"]/6.0)

      {
        x: [lowest_possible, view_left_mid].max,
        y: element_center[:y]
      }
    end

    def right_small_pan_point(uiquery, wait_options={})
      element = wait_for_view(uiquery, wait_options)
      element_center = element_center(element)

      highest_possible = window_size[:width] - 10
      view_right_mid = element_center[:x] + (element["rect"]["width"]/6.0)

      {
        x: [highest_possible, view_right_mid].min,
        y: element_center[:y]
      }
    end

    def point_for_small_pan_start(direction, uiquery, wait_options={})
      case direction
        when :left
          right_small_pan_point(uiquery, wait_options)
        when :right
          left_small_pan_point(uiquery, wait_options)
        when :up
          bottom_small_pan_point(uiquery, wait_options)
        when :down
          top_small_pan_point(uiquery, wait_options)
        else
          raise ArgumentError,
                "Direction #{direction} is not supported; use :left, :right, :top, :bottom"
      end
    end

    def point_for_small_pan_end(direction, uiquery, wait_options={})
      case direction
        when :left
          left_small_pan_point(uiquery, wait_options)
        when :right
          right_small_pan_point(uiquery, wait_options)
        when :up
          top_small_pan_point(uiquery, wait_options)
        when :down
          bottom_small_pan_point(uiquery, wait_options)
        else
          raise ArgumentError,
                "Direction #{direction} is not supported; use :left, :right, :top, :bottom"
      end
    end
    def hit_point_same_as_element_center(hit_point, element_center, delta=20)
      x_diff = (hit_point["x"].to_i - element_center[:x].to_i).abs.to_i
      y_diff = (hit_point["y"].to_i - element_center[:y].to_i).abs.to_i
      x_diff.between?(0, delta) && y_diff.between?(0, delta)
    end
  end
end

World(TestApp::Coordinates)
