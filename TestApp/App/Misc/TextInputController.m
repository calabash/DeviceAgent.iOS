
#import "TextInputController.h"

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

#pragma mark - Actions

- (IBAction)clearTextFieldButtonTouched:(id)sender {
    self.textField.text = @"";
}

- (IBAction)clearTextViewButtonTouched:(id)sender {
    self.textView.text = nil;
}

- (IBAction)dismissTextViewKeyboardButtonTouched:(id)sender {
    [self.textView resignFirstResponder];
}

- (void)handleAlertButtonTouched:(id)sender {
    __block UIAlertController *alert;
    alert = [UIAlertController alertControllerWithTitle:@"Authorize"
                                                message:@"Enter your credentials."
                                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancel, *submit;
    cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * _Nonnull action) {
                                        self.textDelegateMessage.text = @"Cancelled";
                                    }];
    [alert addAction:cancel];

    submit = [UIAlertAction
    actionWithTitle:@"Submit"
              style:UIAlertActionStyleDefault
              handler:^(UIAlertAction * _Nonnull action) {
                  NSArray <UITextField *>*textFields = [alert textFields];
                  NSString *name = textFields[0].text;
                  NSString *pass = textFields[1].text;

                  self.textDelegateMessage.text = [NSString stringWithFormat:@"%@ %@",
                                                   name, pass];
              }];
    [alert addAction:submit];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
        textField.secureTextEntry = NO;
    }];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - View Lifecycle

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setRightBarButtonItem:nil];
    UIBarButtonItem *alertItem;
    alertItem = [[UIBarButtonItem alloc]
                 initWithTitle:@"Alert"
                 style:UIBarButtonItemStylePlain
                 target:self
                 action:@selector(handleAlertButtonTouched:)];
    [self.navigationItem setRightBarButtonItem:alertItem];


    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 18, 10);
    self.textView.textContainerInset = insets;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
