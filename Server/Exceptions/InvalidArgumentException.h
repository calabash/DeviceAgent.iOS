
#import "CBXException.h"

/**
CBXException version of NSInvalidArgumentException.

 Default status code == 200 (currently, client validation must be done by checking
 for the presence or absense of an `"error"` key)
 */

@interface InvalidArgumentException : CBXException
@end
