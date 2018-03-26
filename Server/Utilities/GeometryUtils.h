
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 Utility class for geometry-related functions
 */

@interface GeometryUtils : NSObject
/**
 Determine an offset position for a given finger index.
 Fingers are added as follows:
 
 0: Center (CGPointZero)
 1-4: Staring at 3:00, added in 90º increments CBX_FINGER_WIDTH UI points away from CGPointZero
 
 @param index Index of a finger, 0 - 4
 @return An x,y offset of the finger from CGPointZero.
 */
+ (CGPoint)fingerOffsetForFingerIndex:(int)index;
@end
