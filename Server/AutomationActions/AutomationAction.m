
#import "AutomationAction.h"
#import "CBXException.h"

@implementation AutomationAction

+ (JSONKeyValidator *)validator {
    @throw [CBXException overrideMethodInSubclassExceptionWithClass:self.class
                                                           selector:_cmd];
}

@end
