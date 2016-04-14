
#import "MiscViewController.h"

@interface MiscViewController ()

@end

@implementation MiscViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textfield.delegate = self;
    _textfield.returnKeyType = UIReturnKeyDone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
