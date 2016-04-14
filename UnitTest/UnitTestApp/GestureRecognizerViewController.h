#import <UIKit/UIKit.h>

@interface GestureRecognizerViewController : UIViewController
@property (nonatomic, strong) NSArray <UIGestureRecognizer *> *gestureRecognizers;
- (id)recognizerWithClass:(Class)c;
@end
