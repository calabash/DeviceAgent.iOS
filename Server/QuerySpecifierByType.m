

#import "QuerySpecifierByType.h"
#import "JSONUtils.h"

@implementation QuerySpecifierByType
+ (NSString *)name { return @"type"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    XCUIElementType type = [JSONUtils elementTypeForString:self.value];
    
    /*
     *  It appears when you do a predicate match, the elementType must match _exactly_.
     *  Note: Bug with matchingType:identifier: Even though identifier claimes 'nullable', 
     *  if null it will throw an exception.
     */
    if (type == XCUIElementTypeAny) {
        return query;
    }
    return [query matchingPredicate:[NSPredicate predicateWithFormat:@"elementType == %@", @(type)]];
}
@end
