//
//  GeometryUtils.h
//  CBXDriver
//
//  Created by Chris Fuentes on 4/13/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface GeometryUtils : NSObject
+ (CGPoint)fingerOffsetForFingerIndex:(int)index;
@end
