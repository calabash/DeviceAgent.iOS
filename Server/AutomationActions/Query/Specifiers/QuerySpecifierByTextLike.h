 
#import "QuerySpecifierByText.h"

/**
 Specify elements by text using case- and diacritical-insensitive match. 
 
 See QuerySpecifierText
 
 ## Usage:
 
 { "text_like" : "String" }
 */

@interface QuerySpecifierByTextLike : QuerySpecifierByText<QuerySpecifier>

@end
