
/*
 *  Lots of extra imports here so that all subclasses have them. 
 */
#import "InvalidArgumentException.h"
#import "XCSynthesizedEventRecord.h"
#import "GestureConfiguration.h"
#import "XCPointerEventPath.h"
#import "JSONKeyValidator.h"
#import "XCTouchGesture.h"
#import "XCTestDriver.h"
#import "Testmanagerd.h"
#import "XCTouchPath.h"
#import "CBXProtocols.h"
#import "CBXConstants.h"
#import "Coordinate.h"
#import "CBXTypedefs.h"
#import "JSONUtils.h"
#import "CBXMacros.h"
#import "Query.h"

@class Gesture;
@protocol Gesture <NSObject, JSONKeyValidatorProvider>
@required
+ (NSString *)name;
/*
 *  Depending on the testmanagerd protocol version, only one of these will be used.
 *  The results will be sent via _XCT_synthesizeEvent:completion: or _XCT_performTouchGesture:completion:
 *  respectively.
 *
 *  They should both contain identical logic but using different XC objects to create the gestures.
 */
- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray <Coordinate *> *)coordinates;
- (XCTouchGesture *)gestureWithCoordinates:(NSArray <Coordinate *> *)coordinates;

/*
 * Gestures should specify which keys are necessary (e.g. 'coordinate' for tap_coordinate)
 * as well as which options are available (e.g. 'duration' for tap). 
 * Any keys present besides these should generate a warning and be added to the `warnings` array.
 */

+ (NSArray <NSString *> *)requiredKeys;
+ (NSArray <NSString *> *)optionalKeys;

/*
 * All-in-one constructor / executor.
 */
+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                       query:(Query *)query
                                  completion:(CompletionBlock)completion;
@end

@interface Gesture : AutomationAction<Gesture>

@property (nonatomic, strong) Query *query;
@property (nonatomic, strong) GestureConfiguration *gestureConfiguration;

- (void)execute:(CompletionBlock)completion;
- (id)setup:(NSArray <Coordinate *> *)coords; //any shared setup between eventWithCoordinates: and gestureWithCoordinates:
- (void)validate;   //Validate gestureConfiguration specifics

+ (instancetype)withGestureConfiguration:(GestureConfiguration *)gestureConfig
                                   query:(Query *)query;
+ (NSArray <NSString *> *)defaultOptionalSpecifiers;
@end
