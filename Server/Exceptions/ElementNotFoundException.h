
#import "CBXException.h"

/**
 Exception to be thrown when an element is expected but not found. 
 
 Currently defaults to HTTP status code 200
 */

@interface ElementNotFoundException : CBXException
@end
