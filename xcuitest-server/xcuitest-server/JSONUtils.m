//
//  JSONUtils.m
//  xcuitest-server
//

#import "CBConstants.h"
#import "JSONUtils.h"

@implementation JSONUtils
+ (NSMutableDictionary *)snapshotToJSON:(XCElementSnapshot *)snapshot {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    //TODO: stringify
    json[CB_TYPE_KEY] = @(snapshot.elementType);
    
    json[CB_TITLE_KEY] = snapshot.title ?: CB_EMPTY_STRING;
    json[CB_LABEL_KEY] = snapshot.label ?: CB_EMPTY_STRING;
    json[CB_VALUE_KEY] = snapshot.value ?: CB_EMPTY_STRING;
    json[CB_RECT_KEY] = [self rectToJSON:snapshot.frame];
    json[CB_IDENTIFIER_KEY] = snapshot.identifier ?: CB_EMPTY_STRING;
    json[CB_ENABLED_KEY] = @(snapshot.isEnabled);
    
    //TODO: visibility?
    return json;
}

+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element {
    return [self snapshotToJSON:(XCElementSnapshot *)element];
}

+ (NSDictionary *)rectToJSON:(CGRect)rect {
    return @{
             CB_X_KEY : @(rect.origin.x),
             CB_Y_KEY : @(rect.origin.y),
             CB_HEIGHT_KEY : @(rect.size.height),
             CB_WIDTH_KEY : @(rect.size.width)
             };
}

+ (id)dataToJSON:(NSData *)data {
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}
@end
