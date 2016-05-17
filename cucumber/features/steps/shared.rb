
Given(/^the app has launched$/) do
  ["Touch", "Pan", "Rotate/Pinch", "Misc", "Tao"].each do |mark|
    @waiter.wait_for_view(mark)
  end

  if RunLoop::Environment.ci?
    sleep(15)
  else
    sleep(5)
  end
end

Given(/^I am looking at the (Touch|Pan|Rotate\/Pinch|Misc|Tao) tab$/) do |tabname|
  @gestures.tap_mark(tabname)
  mark = "#{tabname.downcase} page"
  @waiter.wait_for_view(mark)
end

