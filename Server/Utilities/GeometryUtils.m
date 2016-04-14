//
//  GeometryUtils.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/13/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "GeometryUtils.h"
#import "CBXConstants.h"

@implementation GeometryUtils
+ (CGPoint)fingerOffsetForFingerIndex:(int)index {
    index = index % CBX_MAX_NUM_FINGERS;
    switch (index) {
        case 1:
            return CGPointMake(0, CBX_FINGER_WIDTH);
        case 2:
            return CGPointMake(CBX_FINGER_WIDTH, 0);
        case 3:
            return CGPointMake(0, -CBX_FINGER_WIDTH);
        case 4:
            return CGPointMake(-CBX_FINGER_WIDTH, 0);
        case 0:
        default:
            return CGPointZero;
            break;
    }
}

@end
