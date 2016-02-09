//
//  JSONUtils.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "XCElementSnapshot.h"

@interface JSONUtils : NSObject
+ (NSMutableDictionary *)snapshotToJSON:(XCElementSnapshot *)snapshot;
+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element;
+ (XCUIElementType)elementTypeForString:(NSString *)typeString;
@end
