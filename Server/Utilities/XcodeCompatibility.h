#import "XCUIElementQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCUIElementQuery (FBCompatibility)
/**
 Retrieves the snapshot for the given element

 @returns The resolved snapshot
 */
- (XCElementSnapshot *)fb_elementSnapshotForDebugDescription;

@end

NS_ASSUME_NONNULL_END
