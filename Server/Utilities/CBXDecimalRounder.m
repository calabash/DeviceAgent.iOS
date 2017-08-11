
#import "CBXDecimalRounder.h"

static NSRoundingMode const CBXDecimalRounderMode = NSRoundPlain;
static NSUInteger const CBXDecimalRounderDefaultScale = 2;

@interface CBXDecimalRounder ()

- (NSDecimalNumberHandler *)handlerWithMode:(NSRoundingMode)mode
                                       scale:(NSUInteger)scale;
- (NSDecimalNumber *)roundDecimalNumber:(NSDecimalNumber *)decimal
                                handler:(NSDecimalNumberHandler *)handler;
- (CGFloat)cgFloatFromDecimalNumber:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalNumberFromCGFloat:(CGFloat)cgFloat;

@end

@implementation CBXDecimalRounder

- (NSDecimalNumberHandler *)handlerWithMode:(NSRoundingMode)mode
                                      scale:(NSUInteger)scale {
  return [NSDecimalNumberHandler
          decimalNumberHandlerWithRoundingMode:mode
          scale:scale
          raiseOnExactness:YES
          raiseOnOverflow:YES
          raiseOnUnderflow:YES
          raiseOnDivideByZero:YES];
}

- (NSDecimalNumber *)roundDecimalNumber:(NSDecimalNumber *)decimalNumber
                                handler:(NSDecimalNumberHandler *)handler {
  return [decimalNumber decimalNumberByRoundingAccordingToBehavior:handler];
}

- (NSDecimalNumber *)decimalNumberFromCGFloat:(CGFloat)cgFloat {
#if CGFLOAT_IS_DOUBLE
  return [[NSDecimalNumber alloc] initWithDouble:cgFloat];
#else
  return [[NSDecimalNumber alloc] initWithFloat:cgFloat];
#endif
}

- (CGFloat)cgFloatFromDecimalNumber:(NSDecimalNumber *)decimalNumber {
#if CGFLOAT_IS_DOUBLE
  return (CGFloat)[decimalNumber doubleValue];
#else
  return (CGFloat)[decimalNumber floatValue];
#endif
}

- (CGFloat)round:(CGFloat)cgFloat {
  return [self round:cgFloat withScale:CBXDecimalRounderDefaultScale];
}

- (CGFloat)round:(CGFloat)cgFloat withScale:(NSUInteger)scale {
  NSDecimalNumberHandler *handler;
  handler = [self handlerWithMode:CBXDecimalRounderMode
                            scale:scale];

  NSDecimalNumber *decimal = [self decimalNumberFromCGFloat:cgFloat];

  NSDecimalNumber *rounded;
  rounded = [self roundDecimalNumber:decimal handler:handler];
  return [self cgFloatFromDecimalNumber:rounded];
}

- (NSInteger)integerByRounding:(CGFloat)cgFloat {
    return (NSInteger)[self round:cgFloat withScale:0];
}

@end
