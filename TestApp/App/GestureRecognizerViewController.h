#import <UIKit/UIKit.h>

@interface GestureRecognizerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *gestureLabel;
@property (nonatomic, strong) NSArray <UIGestureRecognizer *> *gestureRecognizers;

- (id)recognizerWithClass:(Class)c;
@end
