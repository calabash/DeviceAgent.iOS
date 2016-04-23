
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

/**
 Convenience protocol describing functionality of a Gesture class.
 
 This allows for easy run-time determination of which gestures are currently supported
 such that we can utilize a factory method like that in GestureFactory.
 */

@class Gesture;
@protocol Gesture <NSObject, JSONKeyValidatorProvider>
@required

/**
 All gestures must have a name. This is the value used in the JSON request body to 
 specify which Gesture to invoke.
 */
+ (NSString *)name;

/**---------------------------------------------------------------------------------------
 @name Event Synthesis Methods
---------------------------------------------------------------------------------------
 */

/**
 Used if `testmanagerd.protocolVersion != 0x0`. The results will be sent via 
 _XCT_synthesizeEvent:completion:
 
 @param coordinates An array containing all coordinates from the CoordinateQueryConfiguration.
 **Should contain identical logic to gestureWithCoordinates:**
 */
- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray <Coordinate *> *)coordinates;

/**
 Used if `testmanagerd.protocolVerison == 0x0`. 
 Results will be sent via _XCT_performTouchGesture:completion:
 
 @param coordinates An array containing all coordinates from the CoordinateQueryConfiguration
 **Should contain identical logic to eventWithCoordinates:**
 */
- (XCTouchGesture *)gestureWithCoordinates:(NSArray <Coordinate *> *)coordinates;

/**
An array containing the keys that are necessary for the gesture to be performed 
 (e.g. 'string' for `enter_text`). These keys are fed into a JSONValidator
 which is used in the GestureConfiguration that instantiates the Gesture.
 */

+ (NSArray <NSString *> *)requiredKeys;

/**
An array of optional keys for the gesture (e.g., `degrees` for `rotate`). These
 keys are used to customize the behavior of a gesture but are not required, as 
 default values are specified for every option in CBXConstants.h.
 
 These keys are also fed into a JSONValidator which is used in the GestureConfiguration 
 that instantiates the Gesture.
 */
+ (NSArray <NSString *> *)optionalKeys;

/** 
 All-in-one constructor / executor. 
 
 @param gestureConfig The configuration object used to specify the details of a gesture.
 @param query A query which should resolve to the element(s) on which to perform the gesture. 
 @param completion Block to execute once the gesture has completed.
 */
+ (Gesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                       query:(Query *)query
                                  completion:(CompletionBlock)completion;
@end

@interface Gesture : AutomationAction<Gesture>

@property (nonatomic, strong) Query *query;
@property (nonatomic, strong) GestureConfiguration *gestureConfiguration;


/**
 Performs the gesture
 @param completion Block to execute once the gesture has completed
 @warning The gesture is only performed on the first element result of its query
 */
- (void)execute:(CompletionBlock)completion;

/**
 A convenience method that _can_ be called by eventWithCoordinates: or 
 gestureWithCoordinates: as a shared setup routine.
 
 @param coords  Should correspond to the `coordinates` param of eventWithCoordinates: 
 or gestureWithCoordinates:
 */
- (id)setup:(NSArray <Coordinate *> *)coords;

/**
 Validates a Gesture or throws an exception. By default, the gesture is assumed to be valid.
 However, subclasses of Gesture can override this method to provide actual validation logic.
 
 The validation should be performed against the actual values passed via the GestureConfiguration.
 
 **Note**
 `validate` is currently called on every Gesture during execute:
 */
- (void)validate;

/**
 Convenience constructor.
 @param gestureConfig Configuration (options) to pass to the Gesture
 @param query A query that determines the element on which to perform the gesture.
 @return A new instance of Gesture
 */
+ (instancetype)withGestureConfiguration:(GestureConfiguration *)gestureConfig
                                   query:(Query *)query;

@end
