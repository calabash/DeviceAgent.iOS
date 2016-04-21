
#import "QuerySpecifier.h"

/**
 Given some prior results, specify which index of those results you want. 
 Note that this still returns an NSArray of XCUIElements.
 
 ## Usage:
 
 { "index" : Number }
 
 */
@interface QuerySpecifierByIndex : QuerySpecifier<QuerySpecifier>

@end
