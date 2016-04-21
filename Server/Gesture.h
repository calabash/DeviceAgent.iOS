
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
 
 **Should contain identical logic to gestureWithCoordinates:**
 */
- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray <Coordinate *> *)coordinates;

/**
 Used if `testmanagerd.protocolVerison == 0x0`. 
 Results will be sent via _XCT_performTouchGesture:completion:
 
 **Should contain identical logic to eventWithCoordinates:** 
 */
- (XCTouchGesture *)gestureWithCoordinates:(NSArray <Coordinate *> *)coordinates;

/**
Gestures should specify which keys are necessary (e.g. 'coordinate' for tap_coordinate)
as well as which options are available (e.g. 'duration' for tap).
Any keys present besides these should generate a warning and be added to the `warnings` array.
 */

+ (NSArray <NSString *> *)requiredKeys;
+ (NSArray <NSString *> *)optionalKeys;

/** 
 All-in-one constructor / executor.
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
