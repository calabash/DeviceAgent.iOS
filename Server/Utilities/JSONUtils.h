
#import <Foundation/Foundation.h>
#import "XCUIElement+WebDriverAttributes.h"

/**
 Utilities involving json manipulation, particularly with XCUIElements.
 */
@interface JSONUtils : NSObject
/**
 Convert an object conforming to the FBElement protocol into JSON 
 that can be returned to the client.
 
 Output format is currently:
 
    {
        "type" : String,
        "label" : String,
        "title" : String,
        "value" : String,
        "placeholder" : String,
        "rect" : {
            "width" : Number,
            "height" : Number,
            "x" : Number, //origin.x
            "y" : Number //origin.y
        },
        "id" : String,
        "enabled" : Boolean,
        "test_id" : Number
    }

 @param snapshot XCUIElement or XCElementSnapshot to convert to JSON
 */
+ (NSMutableDictionary *)snapshotToJSON:(NSObject<FBElement> *)snapshot;

/**
 Convenience wrapper for snapshotToJSON:
 @param element XCUIElement to convert to JSON. 
 See snapshotToJSON:
 */
+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element;

/**
 Mapping of a string to an XCUIElementType enum value. E.g.,
 "scrollview" => XCUIElementTypeScrollView
 
 Note the mapping is case-insensitive.
 @param typeString human-readable version of element type
 @return XCUIElementType or -1 if not found.
 */
+ (XCUIElementType)elementTypeForString:(NSString *)typeString;

/**
 Inverse of elementTypeForString: 
 Maps an XCUIElementType to a human-readable string. 
 @param type XCUIElementType
 @return Human-readable string version of the XCUIElementType or `nil` if not found. 
 */
+ (NSString *)stringForElementType:(XCUIElementType)type;

/**
 Validates that given json correctly describes a point. This is convenient
 since a variety of point formats are supported. 
 
 Currently supports:
 
    [ x, y ]
    { "x" : x, "y" : y }
 
 @param json JSON containing point information
 @exception InvalidArgumentException Thrown if the input can not be parsed to a point.
 */
+ (void)validatePointJSON:(id)json;

/**
 Convenience function for generating a CGPoint from valid point JSON. 
 @param json Valid point json
 @return CGPoint representation of the json
 @exception InvalidArgumentException Thrown if the input can not be parsed to a point.
 */
+ (CGPoint)pointFromCoordinateJSON:(id)json;

/**
 Because Objective-C JSON leaves much to be desired (namely, ibuprofen), we've created a convenience
 method to represent a JSON object in a sane, standard way.
 
 @param objcJsonObject Any JSON-serializable object, e.g. NSArray, NSDictionary etc...
 @return Standard json string. 
 E.g.
 
    @{ @"foo" : @"bar"}
 
 turns into
 
    { "foo" : "bar" }
 
 and there was much rejoicing.
 */
+ (NSString *)objToJSONString:(id)objcJsonObject;
@end
