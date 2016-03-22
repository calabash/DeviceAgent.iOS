//
//  JSONUtils.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "XCElementSnapshot.h"

@interface JSONUtils : NSObject
+ (NSMutableDictionary *)snapshotToJSON:(NSObject<XCUIElementAttributes> *)snapshot;
+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element;
+ (XCUIElementType)elementTypeForString:(NSString *)typeString;
+ (CGPoint)pointFromCoordinateJSON:(id)json;
@end
