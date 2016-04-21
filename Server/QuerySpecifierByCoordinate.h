
#import "QuerySpecifier.h"

/**
 Stub specifiers for coordinate queries. 
 
 ## NOTE
 Currently, coordinate-based queries are only supported in conjunction with Gestures, 
 so these don't work for actual element queries.
 
 ## WARNING
 ** Instantiation will throw a CBXException. **
 */

@interface QuerySpecifierByCoordinate : QuerySpecifier<QuerySpecifier>
@end

@interface QuerySpecifierByCoordinates : QuerySpecifier<QuerySpecifier>
@end