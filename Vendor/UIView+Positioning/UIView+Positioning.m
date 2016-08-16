//
//  UIView+Positioning.m
//
//  Created by Shai Mishali on 5/22/13.
//  Copyright (c) 2013 Shai Mishali. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UIView+Positioning.h"

#define SCREEN_SCALE                    ([[UIScreen mainScreen] scale])
#define PIXEL_INTEGRAL(pointValue)      (round(pointValue * SCREEN_SCALE) / SCREEN_SCALE)

@implementation UIView (Positioning)
@dynamic x, y, width, height, origin, size;

// Setters
-(void)setX:(CGFloat)x {
  CGRect r        = self.frame;
  r.origin.x      = PIXEL_INTEGRAL(x);
  self.frame      = r;
}

-(void)setY:(CGFloat)y {
  CGRect r        = self.frame;
  r.origin.y      = PIXEL_INTEGRAL(y);
  self.frame      = r;
}

-(void)setWidth:(CGFloat)width {
  CGRect r        = self.frame;
  r.size.width    = PIXEL_INTEGRAL(width);
  self.frame      = r;
}

-(void)setHeight:(CGFloat)height {
  CGRect r        = self.frame;
  r.size.height   = PIXEL_INTEGRAL(height);
  self.frame      = r;
}

-(void)setOrigin:(CGPoint)origin {
  self.x          = origin.x;
  self.y          = origin.y;
}

-(void)setSize:(CGSize)size {
  self.width      = size.width;
  self.height     = size.height;
}

-(void)setRight:(CGFloat)right {
  self.x = right - self.width;
}

-(void)setBottom:(CGFloat)bottom {
  self.y = bottom - self.height;
}

-(void)setCenterX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}

-(void)setCenterY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}

// Getters
-(CGFloat)x {
  return self.frame.origin.x;
}

-(CGFloat)y {
  return self.frame.origin.y;
}

-(CGFloat)width {
  return self.frame.size.width;
}

-(CGFloat)height {
  return self.frame.size.height;
}

-(CGPoint)origin {
  return CGPointMake(self.x, self.y);
}

-(CGSize)size {
  return CGSizeMake(self.width, self.height);
}

-(CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)centerX {
  return self.center.x;
}

-(CGFloat)centerY {
  return self.center.y;
}

-(UIView *)lastSubviewOnX {
  if(self.subviews.count > 0){
    UIView *outView = self.subviews[0];

    for(UIView *v in self.subviews)
      if(v.x > outView.x)
        outView = v;

    return outView;
  }

  return nil;
}

-(UIView *)lastSubviewOnY {
  if(self.subviews.count > 0){
    UIView *outView = self.subviews[0];

    for(UIView *v in self.subviews)
      if(v.y > outView.y)
        outView = v;

    return outView;
  }

  return nil;
}

// Methods
-(void)centerToParent {
  if(self.superview){
    switch ([UIApplication sharedApplication].statusBarOrientation){
      case UIInterfaceOrientationLandscapeLeft:
      case UIInterfaceOrientationLandscapeRight:{
        self.x  =   PIXEL_INTEGRAL((self.superview.height / 2.0) - (self.width / 2.0));
        self.y  =   PIXEL_INTEGRAL((self.superview.width / 2.0) - (self.height / 2.0));
        break;
      }
      default: {
        // UIInterfaceOrientationUnknown is an iOS 8 symbol.
        // UIDeviceOrientationUnknown <==> UIInterfaceOrientationUnknown

        // case UIInterfaceOrientationPortrait:
        // case UIInterfaceOrientationPortraitUpsideDown:{
        self.x  =   PIXEL_INTEGRAL((self.superview.width / 2.0) - (self.width / 2.0));
        self.y  =   PIXEL_INTEGRAL((self.superview.height / 2.0) - (self.height / 2.0));
        break;
      }
    }
  }
}

@end

