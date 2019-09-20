#import "XCTest+CBXAdditions.h"

@interface XCUIElementQuery (FBCompatibility)
/**
 Retrieves the snapshot for the given element

 @returns The resolved snapshot
 */
- (XCElementSnapshot *)fb_elementSnapshotForDebugDescription;

@end
