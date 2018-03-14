
#import "QuerySpecifierByIndex.h"
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"

@implementation QuerySpecifierByIndex

+ (QuerySpecifierExecutionPriority)executionPriority {
    return kQuerySpecifierExecutionPriorityLast;
}

+ (NSString *)name { return @"index"; }

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    XCUIElement *element = [query elementBoundByIndex:[self.value integerValue]];
    return element.query;
}

@end
