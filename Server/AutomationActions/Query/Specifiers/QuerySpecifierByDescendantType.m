#import "QuerySpecifierByDescendantType.h"
#import "JSONUtils.h"

@implementation QuerySpecifierByDescendantType
+ (NSString *)name { return @"descendant_element"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    NSString *error_message = [NSString stringWithFormat:@"%@%@%@%@",
                               @"Malformed descendant_element value. ",
                               @"Expected dictionary like: ",
                               @"{ 'descendant_type' = Button; 'parent_type' = Keyboard; }",
                               [NSString stringWithFormat:@"but actual is '%@'", self.value]];
    NSAssert([self.value isKindOfClass:[NSDictionary class]], error_message);
    
    NSDictionary *parameters = self.value;
    
    NSAssert(parameters.count == 2,
             @"Dictionary should have only 2 keys '%@' and '%@', but actual is '%@'",
             CBX_PARENT_TYPE_KEY, CBX_DESCENDANT_TYPE_KEY, parameters);
    NSAssert(parameters[CBX_PARENT_TYPE_KEY] != nil,
             @"Value for key '%@' should not be nil. Actual dictionary: %@",
             CBX_PARENT_TYPE_KEY, parameters);
    NSAssert(parameters[CBX_DESCENDANT_TYPE_KEY] != nil,
             @"Value for key '%@' should not be nil. Actual dictionary: %@",
             CBX_DESCENDANT_TYPE_KEY, parameters);
    
    XCUIElementType parentType = [JSONUtils elementTypeForString:parameters[CBX_PARENT_TYPE_KEY]];
    XCUIElementQuery *contextQuery = [query matchingType:parentType identifier:nil];
    
    XCUIElementType descendantType = [JSONUtils elementTypeForString:parameters[CBX_DESCENDANT_TYPE_KEY]];
    XCUIElementQuery *resultQuery = [contextQuery descendantsMatchingType:descendantType];
    
    return resultQuery;
}
@end
