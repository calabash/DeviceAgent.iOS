
module TestApp
  module Query

    # Starting in Xcode 9.3 for iOS >= 11.3
    def newlines_in_queries_supported?
      device_agent_built_with_xcode_gte_93? && ios_gte?("11.3")
    end
  end
end

World(TestApp::Query)

And(/^I am looking at the Query page$/) do
  touch_tab("Misc")
  touch({marked: "query row"})
  wait_for_view({marked: "query page"})
  wait_for_animations
end

Then(/^I query for the Silly Alpha button by mark using id$/) do
  elements = query({marked: "alpha button"})
  expect(elements.count).to be == 1
  expect(elements[0]["id"]).to be == "alpha button"
end

Then(/^I query for the Silly Zero button by mark using the title$/) do
  label = "Zero"
  expected_id = "zero button"
  elements = query({marked: label})
  # `Button` have `StaticText` element as a children in order to visualize its text content starting from iOS 13.
  # Properties `label` of these elements are equals between each other.
  if ios_gte?("13.0")
    expect(elements.count).to be == 2
    button = elements.detect {|e| e["type"] == "Button"}
    expect(button["id"]).to be == expected_id
    static_text = elements.detect {|e| e["type"] == "StaticText"}
    expect(static_text).not_to be nil
    expect(static_text["label"]).to be == label
  else
    expect(elements.count).to be == 1
    expect(elements[0]["id"]).to be == expected_id
  end
end

Then(/^I find the button behind the purple label using marked and :all$/) do
  elements = query({marked: "hidden button", all: true})
  expect(elements.count).to be == 1
  expect(elements[0]["id"]).to be == "hidden button"
end

But(/^I cannot find the button behind the purple label using marked without :all$/) do
  elements = query({marked: "hidden button", all: false})
  expect(elements.count).to be == 0
end

Then(/^I query for Same as views by mark using id$/) do
  elements = query({marked: "same as"})
  expect(elements.count).to be == 7
end

Then(/^I query for Same as views by mark using id and filter by TextField$/) do
  elements = query({marked: "same as", :type => "TextField"})
  expect(elements.count).to be == 2
end

Then(/^I query for Same as views by mark using id and filter by TextView$/) do
  elements = query({marked: "same as", :type => "TextView"})
  expect(elements.count).to be == 2
end

Then(/^I query for Same as views by mark using id and use an index to find the Button$/) do
  elements = query({marked: "same as", :type => "Button"})
  expect(elements.count).to be == 1
  expected = elements[0]

  elements = query({marked: "same as", :index => 5})
  expect(elements.count).to be == 1
  actual = elements[0]

  expect(actual).to be == expected
end

Then(/^I query for the 110 percent by text and mark$/) do
  elements = query({text: "110%"})
  expect(elements.count).to be == 1

  elements = query({marked: "110%"})
  expect(elements.count).to be == 1
end

Then(/^I query for the text with a question mark$/) do
  elements = query({text: "LIKE?"})
  expect(elements.count).to be == 1

  elements = query({marked: "LIKE?"})
  expect(elements.count).to be == 1
end

Then(/^I query for Karl's Problem using a backslash to escape the quote$/) do
  elements = query({marked: "Karl\'s Problem"})
  expect(elements.count).to be == 1

  elements = query({text: "Karl\'s Problem"})
  expect(elements.count).to be == 1
end

Then(/^I query for Karl's Problem without a backslash$/) do
  elements = query({marked: "Karl's Problem"})
  expect(elements.count).to be == 1

  elements = query({text: "Karl's Problem"})
  expect(elements.count).to be == 1
end

Then(/^I query for the text in quotes using backslashes$/) do
  elements = query({marked: "\"quoted\""})
  expect(elements.count).to be == 1

  elements = query({text: "\"quoted\""})
  expect(elements.count).to be == 1
end

Then(/^I query for the text in quotes without using backslashes$/) do
  elements = query({marked: %Q["quoted"]})
  expect(elements.count).to be == 1

  elements = query({text: %Q["quoted"]})
  expect(elements.count).to be == 1
end

Then(/^I query for the label with the TAB by escaping the tab char$/) do
  elements = query({marked: "TAB:\tchar"})
  expect(elements.count).to be == 1

  elements = query({text: "TAB:\tchar"})
  expect(elements.count).to be == 1
end

Then(/^I query for the label with the TAB without escaping the tab char$/) do
  elements = query({marked: "TAB:	char"})
  expect(elements.count).to be == 1

  elements = query({text: "TAB:	char"})
  expect(elements.count).to be == 1
end

And(/^querying for text with newlines works for Xcode 9\.3 and above$/) do
  elements = query({marked: "Here\nthere be\nnewlines"})
  if newlines_in_queries_supported?
    expect(elements.count).to be == 1
  else
    expect(elements.count).to be == 0
  end

  string = %Q[Here
there be
newlines]
  elements = query({marked: string})

  if newlines_in_queries_supported?
    expect(elements.count).to be == 1
  else
    expect(elements.count).to be == 0
  end

  elements = query({text: string})

  if newlines_in_queries_supported?
    expect(elements.count).to be == 1
  else
    expect(elements.count).to be == 0
  end
end

Then(/^I can query for Japanese$/) do
  swipe(:left, "gesture performed")
  elements = query({text: "こんにちは！"})
  expect(elements.count).to be == 1

  swipe(:right, "gesture performed")
  elements = query({text: "またね"})
  expect(elements.count).to be == 1
end

Then(/^an empty hash query returns between (\d+) and (\d+) elements$/) do |lower, upper|
  elements = query_for_automatable_elements({})
  # Results vary per iOS and across simulator and devices.
  # If the @wildcard or @query Scenarios are in isolation, the element count
  # is different than if the the entire test suite is run.
  expect(elements.count).to be >= lower.to_i
  expect(elements.count).to be <= upper.to_i
end

And(/^an empty hash query with :all returns between (\d+) and (\d+) elements$/) do |lower, upper|
  elements = query_for_automatable_elements({all: true})
  # Results vary per iOS and across simulator and devices.
  # If the @wildcard or @query Scenarios are in isolation, the element count
  # is different than if the the entire test suite is run.
  expect(elements.count).to be >= lower.to_i

  if iphone_x? && !device_info["simulator"]
    # Skip this test because there are thousands of views
    # Then an empty hash query returns between 11 and 29 elements
    # RSpec::Expectations::ExpectationNotMetError - expected: <= 32 got: 2112
  else
    expect(elements.count).to be <= upper.to_i
  end
end

Then(/^I ask for the tree representation of the view hierarchy$/) do
  elements = tree
  expect(elements.count).to be >= 7
  expect(elements.count).to be <= 14
end

Then(/^I time how long it takes to make a bunch of queries$/) do
  start = Time.now

  iterations = RunLoop::Environment.xtc? ? 2 : 10
  iterations.times do
    elements = query({marked: "hidden button", all: false})
    expect(elements.count).to be == 0

    elements = query({marked: "same as"})
    expect(elements.count).to be == 7

    elements = query({marked: "same as", :type => "TextField"})
    expect(elements.count).to be == 2

    elements = query({marked: "same as", :type => "TextView"})
    expect(elements.count).to be == 2

    elements = query({marked: "same as", :type => "Button"})
    expect(elements.count).to be == 1
    expected = elements[0]
    elements = query({marked: "same as", :index => 5})
    expect(elements.count).to be == 1
    actual = elements[0]
    expect(actual).to be == expected

    elements = query({text: "110%"})
    expect(elements.count).to be == 1

    elements = query({marked: "110%"})
    expect(elements.count).to be == 1

    elements = query({text: "LIKE?"})
    expect(elements.count).to be == 1

    elements = query({marked: "LIKE?"})
    expect(elements.count).to be == 1

    elements = query({marked: "Karl\'s Problem"})
    expect(elements.count).to be == 1
    elements = query({text: "Karl\'s Problem"})
    expect(elements.count).to be == 1
    elements = query({marked: "Karl's Problem"})
    expect(elements.count).to be == 1
    elements = query({text: "Karl's Problem"})
    expect(elements.count).to be == 1

    elements = query({marked: "\"quoted\""})
    expect(elements.count).to be == 1
    elements = query({text: "\"quoted\""})
    expect(elements.count).to be == 1

    elements = query({marked: %Q["quoted"]})
    expect(elements.count).to be == 1
    elements = query({text: %Q["quoted"]})
    expect(elements.count).to be == 1

    elements = query({marked: "TAB:\tchar"})
    expect(elements.count).to be == 1
    elements = query({text: "TAB:\tchar"})
    expect(elements.count).to be == 1

    elements = query({marked: "TAB:	char"})
    expect(elements.count).to be == 1
    elements = query({text: "TAB:	char"})
    expect(elements.count).to be == 1

    elements = query({marked: "Here\nthere be\nnewlines"})

    if newlines_in_queries_supported?
      expect(elements.count).to be == 1
    else
      expect(elements.count).to be == 0
    end
  end

  elapsed = Time.now - start
  log_inline "Took #{elapsed} seconds to make all those queries"

end

And(/^I am looking at the Text Input with placeholder$/) do
  touch_tab("Misc")
  wait_for_animations
  touch({marked: "text input row", all: true})
  wait_for_view({marked: "text input page"})
  wait_for_animations
end

Then(/^I get empty Text Field by 'type' query and check value$/) do
  expected_placeholder = "Schreib!"
  actual = wait_for_view({type: "TextField"})

  expect(actual["placeholder"]).to be == expected_placeholder
  expect(actual["value"]).to be == expected_placeholder
end

Then(/^I get empty Text Field by 'marked' query and check value$/) do
  expected_placeholder = "Schreib!"
  actual = wait_for_view({marked: "text field"})

  expect(actual["placeholder"]).to be == expected_placeholder
  expect(actual["value"]).to be == expected_placeholder
end

Then(/^I get empty Text Field by 'id' query and check value$/) do
  expected_placeholder = "Schreib!"
  actual = wait_for_view({id: "text field"})

  expect(actual["placeholder"]).to be == expected_placeholder
  expect(actual["value"]).to be == expected_placeholder
end

Then(/^I get empty Text Field by 'text' query and check value$/) do
  expected_placeholder = "Schreib!"
  actual = wait_for_view({text: expected_placeholder})

  expect(actual["value"]).to be == expected_placeholder
end

And (/^I enter text 'Hello!'$/) do
  touch({marked: "text field"})
  enter_text("Hello!")
end

Then(/^I get Text Field by 'type' query and check value$/) do
  expected_text = "Hello!"
  actual = wait_for_view({type: "TextField"})

  expect(actual["value"]).to be == expected_text
end

Then(/^I get Text Field by 'marked' query and check value$/) do
  expected_text = "Hello!"
  actual = wait_for_view({marked: "text field"})

  expect(actual["value"]).to be == expected_text
end

Then(/^I get Text Field by 'id' query and check value$/) do
  expected_text = "Hello!"
  actual = wait_for_view({id: "text field"})

  expect(actual["value"]).to be == expected_text
end

Then(/^I get Text Field by 'text' query and check value$/) do
  expected_text = "Hello!"
  actual = wait_for_view({text: "Hello!"})

  expect(actual["value"]).to be == expected_text
end

Then(/^I get Text Field by 'marked' query with search for entered text$/) do
  entered_text = "Hello!"
  expected_id = "text field"
  actual = wait_for_view({marked: entered_text})

  expect(actual["id"]).to be == expected_id
  expect(actual["value"]).to be == entered_text
end
