
module TestApp
  module Meta

   def xcode_version
     # "0833"
     # "0900"
     version = server_version["xcode_version"]
     chars = version.chars
     if chars[0] == "0"
       major = "#{chars[1]}"
     else
       # Xcode 10 or higher
       major = "#{chars[0]}#{chars[1]}"
     end

     minor = chars[2]
     patch = chars[3]
     RunLoop::Version.new("#{major}.#{minor}.#{patch}")
   end

   def xcode_gte_9?
     xcode_version >= RunLoop::Version.new("9.0.0")
   end
  end
end

World(TestApp::Meta)

Then(/^I can ask for the server version$/) do
  expected =
    {
      "bundle_version" => "1",
      "bundle_identifier" => "com.apple.test.DeviceAgent-Runner",
      "bundle_short_version" => "1.0",
  }

  actual = server_version
  expect(actual["bundle_identifier"]).to be == expected["bundle_identifier"]

  if xcode_gte_9?
    expect(actual["bundle_name"]).to be == "DeviceAgent-Runner"
  else
    expect(actual["bundle_name"]).to be == "DeviceAgent"
  end

  expect(actual["bundle_version"]).to be_truthy
  expect(actual["bundle_short_version"]).to be_truthy
end

And(/^I can ask about the build attributes of the DeviceAgent$/) do
  actual = server_version

  expect(RunLoop::Version.new(actual["platform_version"])).to(
    be >= RunLoop::Version.new("10.0"))
  expect(RunLoop::Version.new(actual["xcode_version"])).to(
    be >= RunLoop::Version.new("7.3.1"))
  expect(RunLoop::Version.new(actual["minimum_os_version"])).to(
    be >= RunLoop::Version.new("8.0"))
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

Then(/^I can tell DeviceAgent not to automatically dismiss SpringBoard alerts$/) do
  expect(set_dismiss_springboard_alerts_automatically(false)).to be_falsey
end

Then(/^I can tell DeviceAgent to automatically dismiss SpringBoard alerts$/) do
  expect(set_dismiss_springboard_alerts_automatically(true)).to be_truthy
end

When(/^I POST \/session again$/) do
  DeviceAgent::Shared.class_variable_set(:@@app_ready, nil)
  DeviceAgent::Automator.client.send(:launch_aut)
end

Then(/^I can tell the AUT has quit because I see the Touch tab$/) do
  wait_for_app
end

Then(/^I can tell the AUT was not quit because I see the Misc tab$/) do
  wait_for_view({marked: "Misc Menu"})
end
