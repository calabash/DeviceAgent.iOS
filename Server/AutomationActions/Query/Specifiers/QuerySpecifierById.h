
#import "QuerySpecifier.h"

/**
 Specify elements by `id`. Seems to correspond to the original UIViews'
    `accessibilityIdentifier`. 
 

## Usage:
 
    { "id" : String }
 
 */
@interface QuerySpecifierById : QuerySpecifier<QuerySpecifier>

@end
