
#import "QuerySpecifier.h"

/**
    Specify elements by `id`. Seems to correspond to the original elements'
    `accessibilityIdentifier`. 
 
    @name Usage
 
    ```
    { "id" : String }
    ```
 */
@interface QuerySpecifierById : QuerySpecifier<QuerySpecifier>

@end
