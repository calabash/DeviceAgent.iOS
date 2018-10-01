#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "XCTestPrivateSymbols.h"
#import "XCElementSnapshot.h"
#import "XCAXClient_iOS.h"
#import "XCUIHitPointResult.h"
#import "CBXConstants.h"
#import "XCUIElement+VisibilityResult.h"

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

#pragma mark - XCElementSnapshot

@implementation XCElementSnapshot (VisibilityResult)

- (id)fb_attributeValue:(NSNumber *)attribute
{
  NSDictionary *attributesResult = [[XCAXClient_iOS sharedClient]
                                    attributesForElementSnapshot:self
                                    attributeList:@[attribute]];
  return (id __nonnull)attributesResult[attribute];
}

- (CBXVisibilityResult *)visibilityResult {
  CBXVisibilityResult *cbxResult = [CBXVisibilityResult new];
  CGPoint intermediate;
  XCUIHitPointResult *result = [self hitPoint:NULL];

  cbxResult.isVisible = result.isHittable;

  if (result.isHittable) {
    intermediate = result.hitPoint;
  } else {
    intermediate = CGPointMake(-1, -1);
  }

  cbxResult.point = intermediate;

  DDLogDebug(@"Finding hit point for XCElementSnapshot: %@\n"
  "hitpoint: %@\n"
  "visible: %@\n",
  self,
  [NSString stringWithFormat:@"(%@, %@)", @(intermediate.x), @(intermediate.y)],
  result.isHittable ? @"YES" : @"NO");
  
  return cbxResult;
}

@end
