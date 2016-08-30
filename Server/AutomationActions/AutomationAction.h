
#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/** AutomationAction is a generic (abstract) superclass for actions which 
 occur during automated user interface testing, namely Gesture and Query.
 
 @warning This class should not be instantiated directly.
 
 See also Gesture and Query
 */

@interface AutomationAction : NSObject<JSONKeyValidatorProvider>
@end
