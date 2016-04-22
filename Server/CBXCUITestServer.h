//
//  CalabashXCUITestServer.h
//

#import <Foundation/Foundation.h>

/**
 HTTP routing server
 */
@interface CBXCUITestServer : NSObject
/**
 Starts the server on the default port
 */
+ (void)start;  //Calabus driver, start your engine!

/**
 Stops the server
 */
+ (void)stop;   //Come to a complete (non-rolling) stop.
@end
