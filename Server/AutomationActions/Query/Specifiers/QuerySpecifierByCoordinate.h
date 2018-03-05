
#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 @name Overview
 Stub specifiers for coordinate queries. 
 
 ## NOTE
 Currently, coordinate-based queries are only supported in conjunction with Gestures, 
 so these don't work for actual element queries.
 
 ## WARNING
 ** Instantiation will throw a CBXException. **
 */

/** Coordinate specifier stub */
@interface QuerySpecifierByCoordinate : QuerySpecifier<QuerySpecifier>
@end

/** Coordinates specifier stub */
@interface QuerySpecifierByCoordinates : QuerySpecifier<QuerySpecifier>
@end
