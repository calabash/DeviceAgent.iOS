
#import <Foundation/Foundation.h>

@class XCUIElementQuery;

/**
    An enum describing the relative execution priority of a specifier.
    Higher-valued specifiers are executed later.
 */
typedef NS_ENUM(int, QuerySpecifierExecutionPriority) {
    /**Execution order doesn't matter*/
    kQuerySpecifierExecutionPriorityAny = 0,
    /** Slight preference for sooner but not crucial */
    kQuerySpecifierExecutionPrioritySooner = -1,
    /** Must be executed first.
     **Onus is put on the programmer to not use this in multiple classes*
     */
    kQuerySpecifierExecutionPriorityFirst = -999,
    /** Slight preference for later but not crucial */
    kQuerySpecifierExecutionPriorityLater = 1,
    /** Must be executed last. 
     **Onus is put on the programmer to not use this in multiple classes*
     */
    kQuerySpecifierExecutionPriorityLast = 999
};

/**
 Protocol to which all all QuerySpecifiers must conform.
 Doing so allows them to be easily picked up at runtime
 and automatically added to the QuerySelectorFactor.
 */

//TODO: Rename Me ?
@protocol QuerySpecifier <NSObject>

/**
 Returns the name of the specifier. This is used in the API as the 'key', e.g.
 for `{ "id" : "foo" }`, the specifier's name would be `"id"`.
 
 @return Selector's name
 */
+ (NSString *)name;

/**
 Actual query-builder logic. This is overridden by subclasses to encapsulate the different
 XCUITest APIs for building a query. 
 
 @param query an input query
 @return the input query further constrained by the current selector.
 */
- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query;

/**
 Convenience constructor
 
 @param value The value that this selector is matching on.
 @return A new QuerySpecifier with the provided value.
 */
+ (instancetype)withValue:(id)value;
@end

/**
 QuerySpecifiers encapsulate individual query components which serve to constrain
 a more general query. 
 
 For example, if you query `{ "key1" : "foo", "key2" : "bar" }`, evaluation is processed
 as follows:
 
 1. Start with a generic 'all' query that matches every element in the application. 
 2. Constrain this query by those elements where 'key1' matches 'foo'.
 3. Further constrain this query by elements where 'key2' matches 'bar.
 
 The end result is an AND-ed query that matches key1 to "foo" and key2 to "bar".
 
 Note that the definition of "match" is dependent on the specifiers' implementation of
 applyInternal: above.
 */

@interface QuerySpecifier : NSObject<QuerySpecifier>
/** 
 Wrapper method for applying a specifier to an input query.
 
 If the input query is `nil`, it will be converted to an `all` query and then passed to 
 `applyInternal` for class-specific matching logic.
 
 @param query Input query or nil
 @return The input query further constrained by the current specifier.
 */
- (XCUIElementQuery *)applyToQuery:(XCUIElementQuery *)query;

/** 
 The value against which this specifier will match.
 */
@property (nonatomic, strong) id value;

/**
    The class's execution priority. Will be the same for all instances of the class.
    @return Class's execution priority
 */
+ (QuerySpecifierExecutionPriority)executionPriority;

/**
 Escapes control characters, single, and double quotes if necessary.

 @param string The string to escape.
 @return String ready for NSPredicate
 */
+ (NSString *)escapeString:(NSString *)string;

@end
