#import "QuerySpecifierByDescendantType.h"
#import "JSONUtils.h"
#import "CBX-XCTest-Umbrella.h"
#import "InvalidArgumentException.h"

@implementation QuerySpecifierByDescendantType
+ (NSString *)name { return @"descendant_element"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSAssert([self.value isKindOfClass:[NSDictionary class]], @"Malformed descendant_element value. Expected dictionary, for example: { 'descendant_type' = Button; 'parent_type' = Keyboard; }, but actual '%@'", self.value);
    
    NSDictionary *parameters = self.value;
        
    NSAssert(parameters.count == 2, @"Dictionary should have only 2 keys '%@' and '%@', but actual dictionary is '%@'", CBX_PARENT_TYPE_KEY, CBX_DESCENDANT_TYPE_KEY, parameters);
    NSAssert(parameters[CBX_PARENT_TYPE_KEY] != nil, @"Value for key '%@' should not be nil. Actual dictionary: %@", CBX_PARENT_TYPE_KEY, parameters);
    NSAssert(parameters[CBX_DESCENDANT_TYPE_KEY] != nil, @"Value for key '%@' should not be nil. Actual dictionary: %@", CBX_DESCENDANT_TYPE_KEY, parameters);
    
    XCUIElementType parentType = [JSONUtils elementTypeForString:parameters[CBX_PARENT_TYPE_KEY]];
    XCUIElementType descendantType = [JSONUtils elementTypeForString:parameters[CBX_DESCENDANT_TYPE_KEY]];
    
    XCUIElementQuery *contextQuery = [query matchingType:parentType identifier:nil];
    
    return [contextQuery descendantsMatchingType:descendantType];;
}
@end
