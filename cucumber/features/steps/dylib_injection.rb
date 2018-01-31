
And(/^I am looking at the Gemuse Me page$/) do
  touch_tab("Misc")
  touch({marked: "gemuse me row"})
  wait_for_view({marked: "gemuse me page"})
  wait_for_animations
end

When(/^running in App Center the Gemuse Bouche libs are loaded$/) do
  if RunLoop::Environment.xtc?
    wait_for_view({marked: "Beta Vulgaris"})
    wait_for_view({marked: "Brassica"})
    wait_for_view({marked: "Curcubits"})
  end
end

When(/^running locally the Gemuse Bouche libs are not loaded$/) do
  if !RunLoop::Environment.xtc?
    wait_for_view({marked: "I am not Gemüsed"})
  end
end
