
#import "XCUIElement+VisibilityResult.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CBX-XCTest-Umbrella.h"
#import "XCAXClient_iOS.h"
#import "XCUIHitPointResult.h"
#import "CBXConstants.h"

@implementation CBXVisibilityResult

@end

@implementation XCUIElement (VisibilityResult)

- (CBXVisibilityResult *)visibilityResult {
  BOOL isVisible = self.isHittable;
  CBXVisibilityResult *result = [CBXVisibilityResult new];
  result.isVisible = isVisible;

  if (!isVisible) {
    result.point = CGPointMake(-1, -1);
  } else {
    // Starting in Xcode 9.3
    if ([self respondsToSelector:@selector(hitPointCoordinate)]) {
      XCUICoordinate *coordinate = self.hitPointCoordinate;
      result.point = coordinate.screenPoint;
    } else {
      return [self.lastSnapshot visibilityResult];
    }
  }
  
  return result;
}

@end
