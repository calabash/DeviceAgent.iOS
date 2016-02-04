//
//  JSONUtils.h
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/3/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCElementSnapshot.h"

@interface JSONUtils : NSObject
+ (NSMutableDictionary *)snapshotToJSON:(XCElementSnapshot *)snapshot;
+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element;
@end
