
#import "QuerySpecifier.h"

/**
 Specify elements by XCUIElementType.
 
 Every XCUIElement has a type. These are encapsulated in a private NS_ENUM 
 called XCUIElementType which can be found in XCUIElementTypes.h.
 
 There is a conversion mechanism for translating between strings and 
 XCUIElement types, see `[JSONUtils elementTypeForString:]`. Basically,
 you can pass in a case-insensitive string version of a type and it will
 be converted to the approprate type, e.g. "button" turns into `XCUIElementTypeButton`
 
 This specifier matches any element belonging to the provided type. 
 
 ## Usage:
 
 { "type" : "String" }
 */
@interface QuerySpecifierByType : QuerySpecifier<QuerySpecifier>
@end
