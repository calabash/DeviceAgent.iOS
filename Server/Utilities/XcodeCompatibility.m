#import "XcodeCompatibility.h"

#import "CBXException.h"
#import "XCUIElementQuery.h"

@implementation XCUIElementQuery (FBCompatibility)

- (XCElementSnapshot *)fb_elementSnapshotForDebugDescription
{
  if ([self respondsToSelector:@selector(elementSnapshotForDebugDescription)]) {
    return [self elementSnapshotForDebugDescription];
  }
  if ([self respondsToSelector:@selector(elementSnapshotForDebugDescriptionWithNoMatchesMessage:)]) {
    return [self elementSnapshotForDebugDescriptionWithNoMatchesMessage:nil];
  }
   @throw [CBXException withFormat:@"Cannot retrieve element snapshots for debug description. Please contact Appium developers"];
  return nil;
}

@end
