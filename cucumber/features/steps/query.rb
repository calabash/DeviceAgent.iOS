
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
  elements = query({marked: "Alpha"})
  expect(elements.count).to be == 1
  expect(elements[0]["id"]).to be == "alpha button"
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
  expected["test_id"] = nil

  elements = query({marked: "same as", :index => 5})
  expect(elements.count).to be == 1
  actual = elements[0]
  actual["test_id"] = nil

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

Then(/^I query for newlines using backslashes$/) do
  elements = query({marked: "Here\nthere be\nnewlines"})
  expect(elements.count).to be == 0

  string = %Q[Here
there be
newlines]
  elements = query({marked: string})
  expect(elements.count).to be == 0
end

Then(/^I can query for Japanese$/) do
  swipe(:left, "gesture performed")
  elements = query({text: "こんにちは！"})
  expect(elements.count).to be == 1

  swipe(:right, "gesture performed")
  elements = query({text: "またね"})
  expect(elements.count).to be == 1
end

Then(/^I query for all visible elements using an empty hash$/) do
  elements = query({})
  if device_info["simulator"]
    expect(elements.count).to be == 19
  else
    expect(elements.count).to be == 20
  end
end

Then(/^I query for all elements using all$/) do
  elements = query({all: true})
  if device_info["simulator"]
    # When the @wildcard or @query Scenarios are run in isolation, the element
    # count is 35.  When run with the complete test suite, there is an extra
    # Window and Other view.
    expect(elements.count).to be >= 35
    expect(elements.count).to be <= 37
  else
    # When the @wildcard or @query Scenarios are run in isolation, the element
    # count is 36.  When run with the complete test suite, there is an extra
    # Window and Other view.
    expect(elements.count).to be >= 36
    expect(elements.count).to be <= 38
  end
end

Then(/^I ask for the tree representation of the view hierarchy$/) do
  elements = tree
  expect(elements.count).to be == 8
end
