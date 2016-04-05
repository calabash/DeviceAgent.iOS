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
#import <Foundation/Foundation.h>
#import "XCPointerEventPath.h"
#import "CBQuery.h"
#import "XCTouchGesture.h"
#import "XCTestDriver.h"
#import "Testmanagerd.h"
#import "CBConstants.h"
#import "CBTypedefs.h"
#import "JSONUtils.h"
#import "CBMacros.h"

@class CBGesture;
@protocol CBGesture <NSObject>
@required
+ (NSString *)name;
/*
 *  Depending on the testmanagerd protocol version, only one of these will be used.
 *  The results will be sent via _XCT_synthesizeEvent:completion: or _XCT_performTouchGesture:completion:
 *  respectively.
 *
 *  They should both contain identical logic but using different XC objects to create the gestures.
 */
- (XCSynthesizedEventRecord *)eventWithElements:(NSArray <XCUIElement *> *)elements;
- (XCTouchGesture *)gestureWithElements:(NSArray <XCUIElement *> *)elements;

/*
 * Gestures should specify which keys are necessary (e.g. 'coordinate' for tap_coordinate)
 * as well as which options are available (e.g. 'duration' for tap). 
 * Any keys present besides these should generate a warning and be added to the `warnings` array.
 */

- (NSArray <NSString *> *)requiredOptions;
- (NSArray <NSString *> *)requiredSpecifiers;
- (NSArray <NSString *> *)optionalOptions;
- (NSArray <NSString *> *)optionalSpecifiers;

/*
 * Should throw an exception if something goes wrong.
 */
- (void)validate;

/*
 * All-in-one constructor / executor.
 */
+ (CBGesture *)executeWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion;
@end

@interface CBGesture : NSObject<CBGesture>
@property (nonatomic, strong) CBQuery *query; /* Identify which element or element */
- (void)execute:(CompletionBlock)completion;
+ (instancetype)withJSON:(NSDictionary *)json;
+ (NSArray <NSString *> *)defaultOptionalSpecifiers;
@end
