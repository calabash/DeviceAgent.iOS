
#import "ViewsToQueryController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewsToQueryController ()
@property (weak, nonatomic) IBOutlet UIView *sameAsView;
@property (weak, nonatomic) IBOutlet UIButton *sameAsButton;
@property (weak, nonatomic) IBOutlet UILabel *sameAsLabel;
@property (weak, nonatomic) IBOutlet UITextField *sameAsTextFieldWithPlaceholder;
@property (weak, nonatomic) IBOutlet UITextField *sameAsTextFieldWithText;
@property (weak, nonatomic) IBOutlet UITextView *sameAsTextView;
@property (weak, nonatomic) IBOutlet UITextView *sameAsTextViewWithText;
@property (weak, nonatomic) IBOutlet UILabel *newlinesLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *controlLabel;
@property (weak, nonatomic) IBOutlet UILabel *quotedLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@end

@implementation ViewsToQueryController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.newlinesLabel.text = @"Here\nthere be\nnewlines";
    self.controlLabel.text = @"TAB:\tchar";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
