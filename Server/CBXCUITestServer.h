//
//  CalabashXCUITestServer.h
//

#import <Foundation/Foundation.h>

@interface CBXCUITestServer : NSObject
+ (void)start;  //Calabus driver, start your engine!
+ (void)stop;   //Come to a complete (non-rolling) stop.
@end
