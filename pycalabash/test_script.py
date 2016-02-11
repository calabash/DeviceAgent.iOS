from pycalabash.xcuitestrun import *

def test_toggle_on_off_labels(app):
    #Go to "general > accessibility"
    general = app.first_element_with_id("General")
    general.tap()

    accessibility = app.first_element_with_id("Accessibility")
    accessibility.tap()

    #find and tap the on/off labels switch
    on_off_labels_switch = app.type_with_label("switch", "On/Off Labels")
    on_off_labels_switch.tap()

    #toggle it once
    back_button = app.first_element_with_id("Back")

    #see what it did
    back_button.tap()

    #go back and toggle it again
    accessibility.tap()
    on_off_labels_switch.tap()

def create_new_event(app):
    #if it's the first launch of calendar, there will be a 'Continue' button
    continue_button = app.first_element_with_id("Continue")
    if continue_button:
        continue_button.tap()

    add_button = app.first_element_with_id("Add")
    add_button.tap()

    title_textfield = app.first_element_marked("Title")
    title_textfield.type_text("Norwegian Metal Concert")

    add_button.tap()

def main():
    test = TestRun("http://127.0.0.1:27753", "com.apple.Preferences")
    test.execute(test_toggle_on_off_labels)

    test.change_app("com.apple.mobilecal")
    test.execute(create_new_event)

if __name__ == main():
    main()
