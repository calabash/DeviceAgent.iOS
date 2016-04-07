//
//  CBGesture.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/17/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

/*
 *  Lots of extra imports here so that all subclasses have them. 
 */
#import "CBInvalidArgumentException.h"
#import "XCSynthesizedEventRecord.h"
#import "GestureConfiguration.h"
#import "XCPointerEventPath.h"
#import "JSONKeyValidator.h"
#import "XCTouchGesture.h"
#import "CBCoordinate.h"
#import "XCTestDriver.h"
#import "XCTouchPath.h"
#import "Testmanagerd.h"
#import "CBProtocols.h"
#import "CBConstants.h"
#import "CBTypedefs.h"
#import "JSONUtils.h"
#import "CBMacros.h"
#import "CBQuery.h"

@class CBGesture;
@protocol CBGesture <NSObject, JSONActionValidatorProvider>
@required
+ (NSString *)name;
/*
 *  Depending on the testmanagerd protocol version, only one of these will be used.
 *  The results will be sent via _XCT_synthesizeEvent:completion: or _XCT_performTouchGesture:completion:
 *  respectively.
 *
 *  They should both contain identical logic but using different XC objects to create the gestures.
 */
- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray <CBCoordinate *> *)coordinates;
- (XCTouchGesture *)gestureWithCoordinates:(NSArray <CBCoordinate *> *)coordinates;

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
+ (CBGesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                         query:(CBQuery *)query
                                    completion:(CompletionBlock)completion;
@end

@interface CBGesture : AutomationAction<CBGesture>

@property (nonatomic, strong) CBQuery *query;
@property (nonatomic, strong) GestureConfiguration *gestureConfiguration;

- (void)execute:(CompletionBlock)completion;
- (void)validate;

+ (instancetype)withGestureConfiguration:(GestureConfiguration *)gestureConfig
                                   query:(CBQuery *)query;
+ (NSArray <NSString *> *)defaultOptionalSpecifiers;
@end
