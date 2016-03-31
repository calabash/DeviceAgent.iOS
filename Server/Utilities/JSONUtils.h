//
//  JSONUtils.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "XCUIElement+WebDriverAttributes.h"

@interface JSONUtils : NSObject
+ (NSMutableDictionary *)snapshotToJSON:(NSObject<FBElement> *)snapshot;
+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element;
+ (XCUIElementType)elementTypeForString:(NSString *)typeString;
+ (NSString *)stringForElementType:(XCUIElementType)type;
+ (CGPoint)pointFromCoordinateJSON:(id)json;
+ (NSString *)objToJSONString:(id)objcJsonObject;
@end
