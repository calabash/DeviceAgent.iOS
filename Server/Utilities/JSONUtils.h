//
//  JSONUtils.h
//  xcuitest-server
//

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

 @param snapshot XCUIElement or XCUIElementSnapshot to convert to JSON
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
 Parse an orientation out of a raw json value passed to the server. 
 @param orientation An integer or string { left, right, up, down }
 @return A UIDeviceOrientation, either cast directly from the input if a number
 was provided, or parsed from the string to correspond to the position of
 the home button. E.g. 'left' means home button is on the left (landscape right)
 @throw CBXException thrown if input is unparseable
 @warn Doesn't validate that input numbers are in a valid range for the UIDeviceOrientation enum. 
 */
+ (UIDeviceOrientation)parseOrientation:(id)orientation;

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
