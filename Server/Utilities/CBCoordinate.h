//
//  CBCoordinate.h
//  CBXDriver
//
//  Created by Chris Fuentes on 4/6/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface CBCoordinate : NSObject
- (CGPoint)cgpoint;
+ (instancetype)fromRaw:(CGPoint)raw;
+ (instancetype)withJSON:(id)json; //throws an exception for invalid JSON
@end
