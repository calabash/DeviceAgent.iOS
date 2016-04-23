//
//  QueryRoutes.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/**
 Routes for querying for elements in the application's view hierarchy. 
 
 ## GET @"/1.0/tree"
 Returns a JSON tree of the application with the XCUIApplication object 
 as the root object. 
 
 ## POST @"/1.0/query" 
    {
        key: val
    }
 
 The JSON body should contain QuerySpecifier key-value pairs. See QuerySpecifier. 
 This also corresponds to the `specifiers` field in a Gesture. See GestureRoutes.
 
 ## POST @"/query/marked/:text"
 **Deprecated**
 Don't do it.
 
 ## POST @"/query/id/:id"
 **Deprecated**
 Don't do it.
 
 ## POST @"/query/type/:type"
 **Deprecated**
 Don't do it.
 
 */
@interface QueryRoutes : NSObject<CBRouteProvider>

@end
