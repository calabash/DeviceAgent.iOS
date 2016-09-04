
Then(/^I can ask for the server version$/) do
  expected =
    {
      "bundle_version" => "1",
      "bundle_identifier" => "com.apple.test.DeviceAgent-Runner",
      "bundle_short_version" => "1.0",
      "bundle_name" => "DeviceAgent"
  }

  actual = server_version
  expect(actual["bundle_identifier"]).to be == expected["bundle_identifier"]
  expect(actual["bundle_name"]).to be == expected["bundle_name"]
  expect(actual["bundle_version"]).to be_truthy
  expect(actual["bundle_short_version"]).to be_truthy
end

Then(/^I can ask for the session identifier$/) do
  identifier = session_identifier

  expect(identifier).not_to be == nil
  expect(identifier.count).not_to be == 0
end

Then(/^I can ask for information about the device under test$/) do
  expect(device_info.empty?).to be_falsey
end

Then(/^I can ask for the pid of the server$/) do
  pid = server_pid
  expect(pid).not_to be == nil
  expect(pid.count).not_to be == 0
end
