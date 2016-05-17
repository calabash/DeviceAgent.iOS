
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@interface TouchPath : NSObject
@property (nonatomic, readonly) NSInteger orientation;

+ (instancetype)withFirstTouchPoint:(CGPoint)firstTouchPoint orientation:(NSInteger)orientation;
- (void)moveToNextPoint:(CGPoint)nextPoint afterSeconds:(CGFloat)seconds;
- (void)liftUpAtPoint:(CGPoint)finalPoint afterSeconds:(CGFloat)seconds;
@end
