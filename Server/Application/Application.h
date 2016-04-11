//
//  CBApplication.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "XCUIApplication.h"

@interface Application : NSObject
+ (void)launchBundlePath:(NSString *_Nullable)bundlePath
                bundleID:(NSString *_Nonnull)bundleID
              launchArgs:(NSArray *_Nullable)launchArgs
                     env:(NSDictionary *_Nullable)environment;

+ (XCUIApplication *_Nonnull)currentApplication; //TODO: I want to hide this somehow. -CF
+ (NSNumber *_Nonnull)cacheElement:(XCUIElement  * _Nonnull)el;
+ (XCUIElement *_Nullable)cachedElementOrThrow:(NSNumber *_Nonnull)index;
+ (void)killCurrentApplication;
+ (BOOL)hasSession;

@end
