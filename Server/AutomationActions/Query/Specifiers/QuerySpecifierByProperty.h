
#import <Foundation/Foundation.h>
#import "QuerySpecifier.h"

/**
 Specify elements by property value.
 
 This QuerySpecifier allows for more efficient selection by a specific property.
 For example, QuerySpecifierByTextLike combines several sub-predicates to create a
 query that might match one of many fields containing some text. If you happen to know
 that you are looking only for the `placeholderText`, you can use `QuerySpecifierByProperty`
 to only match on that field. 
 
 
 ## Usage:
 
    { "property" : "<String>=\"<String>\"" }
    OR
    { "property" : { "key|property|using" : String, "value" : String } }
 
 ### Examples
    { "property" : "title=\"Banana\"" }
    { "property" : { "key" : "title", "value" : "\"Banana\"" }
    { "property" : { "property" : "title", "value" : "\"Banana\"" }
    { "property" : { "using" : "title", "value" : "\"Banana\"" }
 
 **NOTE** 
 String values must be in escaped quotes. This tells Objective C to differentiate them from
 primitives. E.g. 
 
     { "property" : "hasKeyboardFocus=YES" }
 
    vs
 
     { "property" : "label=\"YES\"" }
 
 
 */

// TODO: Perhaps make a class method that returns all supported properties?
@interface QuerySpecifierByProperty : QuerySpecifier<QuerySpecifier>

/**
Parses a digestible value object out of raw value JSON.
 
 Since a variety of formats are supported for property values, this method
 is used to normalize them into a unified form. 
 
 @param value The original JSON value of the property in question
 @return A dictionary of the form { "key" : <property_key>, "value" : <property_value> }
 */
+ (NSDictionary <NSString *, id> *)parseValue:(id)value; // @{ @"key" : string, @"value" : id }
@end
