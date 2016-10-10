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
        fail(%Q[#{message}:
Expected text: #{expected}
          got: #{actual}
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
  # nop
end

Given(/^I replace "([^\"]*)" with "([^\"]*)" by sending backspace$/) do |to_replace, replacement|
  replace_last_chars(to_replace, replacement, :backspace)
  text = text_from_text_field
  answer = compose_answer(text)
  wait_for_question_text(answer)
end

And(/^I decide I want to be more emphatic$/) do
  # nop
end

Then(/^I replace "([^\"]*)" with "([^\"]*)" using the delete key$/) do |to_replace, replacement|
  replace_last_chars(to_replace, replacement, :delete_key)
  text = text_from_text_field
  answer = compose_answer(text)
  wait_for_question_text(answer)
end

And(/^I clear the text$/) do
  clear_text()
end

Then(/^I should see an empty text field$/) do
  actual_text = text_from_text_field
  expect_text("", actual_text, "Error deleting text")
end
