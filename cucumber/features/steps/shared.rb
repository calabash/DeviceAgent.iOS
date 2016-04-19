
Given(/^the app has launched$/) do
  # Wait for a view
  if RunLoop::Environment.ci?
    sleep(30.0)
  else
    sleep(5.0)
  end
end

