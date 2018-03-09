
module TestApp
  module Meta
    def launch_aut_with_term_aut(true_or_false)
      DeviceAgent::Shared.class_variable_set(:@@app_ready, nil)
      client = DeviceAgent::Automator.client
      options = client.send(:launcher_options)
      original_value = options[:terminate_aut_before_test]
      options[:terminate_aut_before_test] = true_or_false
      client.send(:launcher_options!, options.dup)

      begin
        DeviceAgent::Automator.client.send(:launch_aut)
        wait_for_app(:skip_touch_check)
      ensure
        options[:terminate_aut_before_test] = original_value
      end
    end

    def get_xcode_element_types
      xct_path = Dir.glob("#{RunLoop::Xcode.new.developer_dir}/**/XCTest")
                    .detect { |f| f.include? "iPhoneOS" }
      args = ["xcrun", "strings", xct_path]
      hash = RunLoop::Shell.run_shell_command(args)
      types = hash[:out].split("\n")
                        .select { |line| /^XCUIElementType\w/.match line }
                        .map { |line| line.gsub("XCUIElementType", "").downcase }
                        .sort
      # We don't need XCUIElementTypeQueryProvider
      types - ["queryprovider"]
    end
  end
end

World(TestApp::Meta)

And(/^I make a note of the AUT pid and test-session identifier$/) do
  @aut_pid = process_pid("sh.calaba.TestApp")
  @session_identifier = session_identifier["sessionId"]
end

Then(/^I can ask for the server version$/) do
  expected =
    {
      "bundle_version" => "1",
      "bundle_identifier" => "com.apple.test.DeviceAgent-Runner",
      "bundle_short_version" => "1.0",
  }

  actual = server_version
  expect(actual["bundle_identifier"]).to be == expected["bundle_identifier"]

  if device_agent_built_with_xcode_gte_9?
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

Then(/^I can ask for the test-session identifier$/) do
  hash = session_identifier

  expect(hash).not_to be == nil
  expect(hash.count).not_to be == 0
  expect(hash["sessionId"]).not_to be == nil
end

Then(/^I can ask for information about the device under test$/) do
  expect(device_info.empty?).to be_falsey
end

Then(/^I can ask for the pid of the AUT$/) do
  pid = process_pid("sh.calaba.TestApp")
  expect(pid).not_to be == nil
  expect(pid).not_to be == 0
end

Then(/^I can tell DeviceAgent not to automatically dismiss SpringBoard alerts$/) do
  expect(set_dismiss_springboard_alerts_automatically(false)).to be_falsey
end

Then(/^I can tell DeviceAgent to automatically dismiss SpringBoard alerts$/) do
  expect(set_dismiss_springboard_alerts_automatically(true)).to be_truthy
end

Then(/^I can compare Xcode element types with DeviceAgent supported element types$/) do
  xcode_types = get_xcode_element_types
  expect(xcode_types - element_types).to be_empty
end

When(/^I POST \/session again with term-on-launch (true|false)$/) do |true_or_false|
  if true_or_false == "true"
    launch_aut_with_term_aut(true)
  else
    launch_aut_with_term_aut(false)
  end
end

Then(/^I can tell the AUT has quit because I see the Touch tab$/) do
  wait_for_app
end

Then(/^I can tell the AUT was not quit because I see the Misc tab$/) do
  wait_for_view({marked: "Misc Menu"})
end

And(/^I can tell the AUT has quit because the pid is different$/) do
  aut_pid = process_pid("sh.calaba.TestApp")
  expect(aut_pid).not_to be == @aut_pid
end

And(/^I can tell the AUT has not quit because the pid is the same$/) do
  aut_pid = process_pid("sh.calaba.TestApp")
  expect(aut_pid).to be == @aut_pid
end

And(/^I can tell there is a new session because the identifier changed$/) do
  identifier = session_identifier["sessionId"]
  expect(identifier).not_to be == @session_identifier
end

And(/^the DeviceAgent test-session has not changed$/) do
  identifier = session_identifier["sessionId"]
  expect(identifier).to be == @session_identifier
end

When(/^I POST \/terminate$/) do
  expect(app_running?("sh.calaba.TestApp")).to be_truthy
  hash = terminate("sh.calaba.TestApp")
  expect(hash["state"]).to be == 1
end

When(/^I DELETE \/session$/) do
  DeviceAgent::Shared.class_variable_set(:@@app_ready, nil)
  hash = session_delete
  expect(hash["state"]).to be == 1
end

Then(/^the AUT pid is zero$/) do
  aut_pid = process_pid("sh.calaba.TestApp")
  expect(aut_pid).not_to be == 0
end
