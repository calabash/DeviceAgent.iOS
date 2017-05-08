
Then(/^I can find the on-off switch by (identifier|type)$/) do |method|
  if method == "identifier"
    wait_for_view({marked: "switch"})
  else
    wait_for_view({type: "Switch"})
  end
end

Then(/^the on-off switch is on$/) do
  result = wait_for_view({marked: "switch"})
  expect(result["value"]).to be == "1"
end

Then(/^I can turn the switch off$/) do
  touch({type: "Switch"})
  result = wait_for_view({marked: "switch"})
  expect(result["value"]).to be == "0"
end

Then(/^I can find the segmented control by (identifier|type)$/) do |method|
  if method == "identifier"
    wait_for_view({marked: "segmented"})
  else
    wait_for_view({type: "SegmentedControl"})
  end
end

Then(/^the (First|Second|Third) control is selected$/) do |control|
  result = wait_for_view({marked: control})
  expect(result["selected"]).to be == true
  others = ["First", "Second", "Third"] - [control]
  others.each do |mark|
    view = query({marked: mark}).first
    expect(view["selected"]).to be == false
  end
end

When(/^I touch the (First|Second|Third) control$/) do |control|
  touch({marked: control})
  wait_for_animations
end
