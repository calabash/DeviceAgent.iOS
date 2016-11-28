
#import "TextInputController.h"
#import <AVFoundation/AVFoundation.h>

@interface TextInputController ()
@property (weak, nonatomic) IBOutlet UILabel *textDelegateMessage;
@property (weak, nonatomic) IBOutlet UILabel *howGoesItLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *clearTextFieldButton;
- (IBAction)clearTextFieldButtonTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *clearTextView;
- (IBAction)clearTextViewButtonTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dismissTextViewKeyboardButton;
- (IBAction)dismissTextViewKeyboardButtonTouched:(id)sender;


@end

static NSString *const kCaVa = @"Ça va?";

@implementation TextInputController

- (void)viewDidLoad {
    [super viewDidLoad];

    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.clearButtonMode = UITextFieldViewModeAlways;

  _textView.delegate = self;

    UITapGestureRecognizer *recognizer;
    recognizer = [[UITapGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(handleTapOnTouchQuestionLabel:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [self.howGoesItLabel addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleTapOnTouchQuestionLabel:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    if (UIGestureRecognizerStateEnded == state) {
        UIView *view = recognizer.view;
        if (view == self.howGoesItLabel) {
            if (recognizer.numberOfTouches == 1) {
                self.howGoesItLabel.text = kCaVa;
            }
        }
    }
}

- (IBAction)clearTextFieldButtonTouched:(id)sender {
    self.textField.text = @"";
}

- (IBAction)clearTextViewButtonTouched:(id)sender {
  self.textView.text = nil;
}

- (IBAction)dismissTextViewKeyboardButtonTouched:(id)sender {
  [self.textView resignFirstResponder];
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textDelegateMessage.text = @"textFieldShouldBeginEditing:";
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textDelegateMessage.text = @"textFieldDidBeginEditing:";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.textDelegateMessage.text = @"textFieldShouldEndEditing:";
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.textDelegateMessage.text = @"textFieldDidEndEditing:";
}

- (BOOL)textField:(UITextField *)textField
 shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string  {
    self.textDelegateMessage.text = @"textField:shouldChangeCharactersInRange:replacementString:";

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField  {
    self.textDelegateMessage.text = @"textFieldShouldClear:";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.textDelegateMessage.text = @"textFieldShouldReturn:";
    [textField resignFirstResponder];
    NSString *answer = [NSString stringWithFormat:@"%@ - %@",
                        kCaVa, textField.text];
    self.howGoesItLabel.text = answer;
    return YES;
}

#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
   self.textDelegateMessage.text = @"textViewShouldBeginEditing:";
   return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
   self.textDelegateMessage.text = @"textViewDidBeginEditing";
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  self.textDelegateMessage.text = @"textViewShouldEndEditing";
  return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  self.textDelegateMessage.text = @"textViewDidEndEditing:";
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text {
  self.textDelegateMessage.text = @"textView:shouldChangeTextInRange:replacementText:";
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
   self.textDelegateMessage.text = @"textViewDidChange:";
}

@end
