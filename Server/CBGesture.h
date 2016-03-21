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
#import "CBElementQuery.h"
#import "XCTouchGesture.h"
#import "XCTestDriver.h"
#import "Testmanagerd.h"
#import "CBConstants.h"
#import "CBTypedefs.h"
#import "JSONUtils.h"
#import "CBMacros.h"

@class CBGesture;
@protocol CBGesture <NSObject>
+ (NSString *)name;
/*
 *  Depending on the testmanagerd protocol version, only one of these will be used.
 *  The results will be sent via _XCT_synthesizeEvent:completion: or _XCT_performTouchGesture:completion:
 *  respectively.
 *
 *  They should both contain identical logic but using different XC objects to create the gestures.
 */
- (XCSynthesizedEventRecord *)event;
- (XCTouchGesture *)gesture;

- (void)validate; //Should throw an exception if something goes wrong.

+ (CBGesture *)executeWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion;
@end

@interface CBGesture : NSObject<CBGesture>
@property (nonatomic, strong) CBElementQuery *query; /* Identify which element or element */
@end
