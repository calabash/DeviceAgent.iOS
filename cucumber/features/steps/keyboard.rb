module DeviceAgent
  module Keyboard

    QUESTION = "Ça va?"

    def wait_for_question_text(text)
      wait_for_text_in_view(text, {marked: "question"})
    end

    def wait_for_question_reset
      wait_for_question_text(QUESTION)
    end

    def wait_for_text_field(text)
      wait_for_text_in_view(text, {marked: "text field"})
    end

    def text_from_text_field
      result = wait_for_view({marked: "text field"})
      result["value"]
    end

    def wait_for_text_field_reset
      wait_for_question_text(QUESTION)
    end

    def compose_answer(answer)
      "#{QUESTION} - #{answer}"
    end

    def trim_n_chars_from_end(string, n)
      string[0...(-1 * n)]
    end

    def delete_last_n_chars(n, delete_with)
      n.times do
        case delete_with
        when :backspace
          delete_with_backspace_char
        when :delete_key
          touch_keyboard_delete_key
        else
          raise ArgumentError, "Unsupported delete_with: #{delete_with}"
        end
      end
    end

    def expect_text(expected, actual, message)
      if expected != actual

        if expected.nil?
          expected_message = "nil"
        else
          expected_message = expected
        end

        if actual.nil?
          actual_message = "nil"
        else
          actual_message = actual
        end

        fail(%Q[
#{message}

Expected text: #{expected_message}
          got: #{actual_message}
])
      end
    end

    def replace_last_chars(to_replace, replacement, delete_with)
      text_before = text_from_text_field
      n = to_replace.length
      delete_last_n_chars(n, delete_with)

      expected_after_delete = trim_n_chars_from_end(text_before, n)
      actual_after_delete = text_from_text_field
      expect_text(expected_after_delete, actual_after_delete,
                  "Error deleting text")

      enter_text(replacement)
      @last_text_entered = replacement
      touch({marked: "Done"})

      expected_after_replacement = "#{actual_after_delete}#{replacement}"
      actual_after_replacement = text_from_text_field

      expect_text(expected_after_replacement, actual_after_replacement,
                  "Error entering text")
    end
  end
end

World(DeviceAgent::Keyboard)

And(/^I am looking at the Text Input page$/) do
  touch_tab("Misc")
  wait_for_animations
  touch({marked: "text input row", all: true})
  wait_for_view({marked: "text input page"})
  wait_for_animations
end

And(/^the text field and question label are reset$/) do
  touch({marked: "question"})
  wait_for_question_reset

  touch({marked: "clear text field button"})
  wait_for_text_field_reset
end

When(/^I try to type without the keyboard$/) do
  expect(keyboard_visible?).to be_falsey

  begin
    enter_text("Gut, und Sie?")
    @last_text_entered = "Gut, und Sie?"
  rescue => e
    @last_error = e
  end
end

Then(/^a keyboard-not-visible error is raised$/) do
  expect(@last_error).to be_truthy
  expect(@last_error.message[/Keyboard must be visible/]).to be_truthy
end

When(/^I touch the text field$/) do
  touch({marked: "text field"})
end

Then(/^the keyboard is visible$/) do
  wait_for_keyboard
end

And(/^the text (field|view) has keyboard focus$/) do |type|
  if type == "field"
    text_field = query({marked: "text field"}).first
  else
    text_field = query({marked: "text view"}).first
  end
  expect(text_field["has_keyboard_focus"]).to be == true
end

Then(/^the UIKeyInput view does _not_ have keyboard focus$/) do
  input_field = query({marked: "key input"}).first
  expect(input_field["has_keyboard_focus"]).to be == false
end

When(/^I type "([^\"]*)"$/) do |text|
  enter_text(text)
  @last_text_entered = text
end

Then(/^what I typed appears in the red box$/) do
  touch({marked: "Done"})
  answer = compose_answer(@last_text_entered)
  wait_for_question_text(answer)
end

Given(/^I typed "([^\"]*)"$/) do |text|
  enter_text_in({marked: "text field"}, text)
  @last_text_entered = text
end

And(/^I decide I should be more formal$/) do
  # documentation step
end

Given(/^I replace "([^\"]*)" with "([^\"]*)" by sending backspace$/) do |to_replace, replacement|
  replace_last_chars(to_replace, replacement, :backspace)
  text = text_from_text_field
  answer = compose_answer(text)
  wait_for_question_text(answer)
end

And(/^I decide I want to be more emphatic$/) do
  # documention step
end

Then(/^I replace "([^\"]*)" with "([^\"]*)" using the delete key$/) do |to_replace, replacement|
  replace_last_chars(to_replace, replacement, :delete_key)
  text = text_from_text_field
  answer = compose_answer(text)
  wait_for_question_text(answer)
end

And(/^I clear the text$/) do
  clear_text
end

Then(/^I should see an empty text field$/) do
  actual_text = text_from_text_field
  expect_text(nil, actual_text, "Error clearing text")
end

Given(/^I touched the Text View$/) do
  query = {marked: "text view"}
  wait_for_view(query)
  touch(query)
  wait_for_keyboard
end

Then(/^I can clear the Text View$/) do
  touch({marked: "clear text view button"})
end

Then(/^I can type a lot of text$/) do
  text = %Q[Grünliche Dämmerung, nach oben zu lichter, nach unten zu dunkler.
Die Höhe ist von wogendem Gewässer erfüllt, das rastlos von rechts nach links zu
strömt. Nach der Tiefe zu lösen die Fluten sich in einen immer feineren feuchten
Nebel auf, so dass der Raum in Manneshöhe vom Boden auf gänzlich frei vom Wasser
zu sein scheint, welches wie in Wolkenzügen über den nächtlichen Grund dahinfliesst.

Überall ragen schroffe Felsenriffe aus der Tiefe auf und grenzen den Raum der
Bühne ab; der ganze Boden ist in ein wildes Zackengewirr zerspalten, so dass er
nirgends vollkommen eben ist und nach allen Seiten hin in dichtester Finsternis
tiefere Schlüfte annehmen lässt.
]

  enter_text(text)
end

And(/^I can dismiss the Text View keyboard$/) do
  touch({marked: "dismiss text view keyboard"})
  wait_for_no_keyboard
end

And(/^I can select all the text in the Text View$/) do
  touch({marked: "text view"}, {duration: 1.0})
  query = {marked: "Select All" }
  wait_for_view(query)
  2.times { wait_for_animations }
  touch(query)
  2.times { wait_for_animations }
end

But(/^I can clear the Text View after selecting all using the delete key or Cut$/) do
  # Cut sometimes appears, sometimes it does not.
  query = {marked: "Cut" }

  if !query(query).empty?
    touch(query)
  else
    query = {marked: "delete", type: "Key"}
    wait_for_view(query)
    touch(query)
    wait_for_animations
  end

  wait_for_text_in_view(nil, {marked: "text view"})
end

Given(/^I touch the Alert nav bar button$/) do
  query = {marked: "Alert", type: "Button"}
  wait_for_view(query)
  touch(query)
end

Then(/^I see an authentication alert$/) do
  wait_for_view({marked: "Authorize"})
  wait_for_animations
end

Then(/^I enter my name for authentication$/) do
  touch({marked: "Name"})
  wait_for_keyboard
  enter_text("clever-user")
end

Then(/^I enter my password for authentication$/) do
  touch({marked: "Password"})
  wait_for_keyboard
  enter_text("pa$$w0rd")
  wait_for_animations
end

Then(/^I submit my credentials for authentication$/) do
  wait_for_animations
  touch({marked: "Submit"})
  wait_for_animations

  wait_for_text_in_view("clever-user pa$$w0rd", {marked: "text delegate"})
end

Given(/^I touched the UIKeyInput view$/) do
  touch({marked: "key input"})
  wait_for_keyboard
  wait_for_animations
end

When(/^I try to use the clear text gesture on the UIKeyInput view$/) do
  # documentation step
end

Then(/^an error is raised because DeviceAgent cannot find a first responder$/) do
  expect do
    clear_text
  end.to raise_error(RuntimeError, /Can not clear text: no element has focus/)
end

Then(/^I type some text in the UIKeyInput view$/) do
  touch({marked: "clear key input button"})
  wait_for_text_in_view("", {marked: "key input"})

  string = "This is a UIKeyInput view"
  enter_text(string)
  wait_for_text_in_view(string, {marked: "key input"})
end

Then(/^I can delete text in the UIKeyInput view by tapping the keyboard delete key$/) do
  result = wait_for_view({marked: "key input"})
  string = result["label"] || result["value"]
  string.each_char do |_|
    touch_keyboard_delete_key
    sleep(0.1)
  end

  wait_for_text_in_view("", {marked: "key input"})
end

And(/^I dismiss the UIKeyInput keyboard by tapping the return button$/) do
  enter_text("\n")
  wait_for_no_keyboard
end
