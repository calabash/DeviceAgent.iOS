
#import "CBXOrientation.h"
#import "Application.h"
#import "XCUIDevice.h"
#import "SpringBoard.h"

@implementation CBXOrientation

+ (UIDeviceOrientation)deviceOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortrait: return UIDeviceOrientationPortrait;
        case UIInterfaceOrientationPortraitUpsideDown: return UIDeviceOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft: return UIDeviceOrientationLandscapeRight;
        case UIInterfaceOrientationLandscapeRight: return UIDeviceOrientationLandscapeLeft;
        default: return UIDeviceOrientationUnknown;
    }
}

+ (UIDeviceOrientation)UIDeviceOrientation {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    return orientation;
}

+ (UIDeviceOrientation)XCUIDeviceOrientation {
    return [[XCUIDevice sharedDevice] orientation];
}

+ (UIDeviceOrientation)AUTOrientation {
    UIInterfaceOrientation orientation = [[Application currentApplication]
                                          interfaceOrientation];
    return [CBXOrientation deviceOrientation:orientation];
}

+ (UIDeviceOrientation)SpringBoardOrientation {
    UIInterfaceOrientation orientation = [[SpringBoard application] interfaceOrientation];
    return [CBXOrientation deviceOrientation:orientation];
}

+ (NSDictionary *)orientations {
    UIDeviceOrientation UIDevice = [CBXOrientation UIDeviceOrientation];
    UIDeviceOrientation XCUIDevice = [CBXOrientation XCUIDeviceOrientation];
    UIDeviceOrientation AUT = [CBXOrientation AUTOrientation];
    UIDeviceOrientation SpringBoard = [CBXOrientation SpringBoardOrientation];
    NSUInteger active;
    active = [CBXOrientation UIApplicationOrientationWithSelectorName:@"activeInterfaceOrientation"];
    
    return
    @{
      @"UIDevice" : @[@(UIDevice),
                      [CBXOrientation stringForOrientation:UIDevice]],
      @"XCUIDevice" : @[@(XCUIDevice),
                        [CBXOrientation stringForOrientation:XCUIDevice]],
      @"AUT" : @[@(AUT),
                 [CBXOrientation stringForOrientation:AUT]],
      @"SpringBoard_XCUIApplication" :
          @[@(SpringBoard), [CBXOrientation stringForOrientation:SpringBoard]],
      @"UIApplication_activeInterfaceOrientation" :
          @[@(active), [CBXOrientation stringForOrientation:active]]
      };
}

+ (NSUInteger)UIApplicationOrientationWithSelectorName:(NSString *)selectorName {
    SEL selector = NSSelectorFromString(selectorName);
    if (![[UIApplication sharedApplication] respondsToSelector:selector]) {
        NSLog(@"UIApplication does not respond to selector %@", selectorName);
        return NSNotFound;
    }
    
    NSMethodSignature *signature;
    signature = [[UIApplication class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation;
    
    invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = [UIApplication sharedApplication];
    invocation.selector = selector;
    
    [invocation invoke];
    
    NSUInteger orientation;
    [invocation getReturnValue:(void **) &orientation];
    
    return orientation;
}

+ (NSString *)stringForOrientation:(NSUInteger)orientation {
    if (orientation == UIDeviceOrientationUnknown ||
        orientation == UIInterfaceOrientationUnknown) {
        return @"unknown";
    }
    
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIDeviceOrientationPortrait) {
        return @"portrait";
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown ||
        orientation == UIDeviceOrientationPortraitUpsideDown) {
        return @"upside_down";
    }
    
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight) {
        return @"right";
    }
    
    if (orientation == UIInterfaceOrientationLandscapeRight ||
        orientation == UIDeviceOrientationLandscapeLeft) {
        return @"left";
    }
    
    if (orientation == UIDeviceOrientationFaceUp) {
        return @"face_up";
    }
    
    if (orientation ==  UIDeviceOrientationFaceDown) {
        return @"face_down";
    }
    
    return @"";
}

+ (UIDeviceOrientation)orientationForString:(NSString *)string {
    if ([@"portrait" isEqualToString:string]) { return UIDeviceOrientationPortrait; }
    
    if ([@"upside_down" isEqualToString:string]) {
        return UIDeviceOrientationPortraitUpsideDown;
    }
    
    if ([@"left" isEqualToString:string]) { return UIDeviceOrientationLandscapeLeft; }
    
    if ([@"right" isEqualToString:string]) { return UIDeviceOrientationLandscapeRight; }
    
    if ([@"face_up" isEqualToString:string]) { return UIDeviceOrientationFaceUp; }
    
    if ([@"face_down" isEqualToString:string]) { return UIDeviceOrientationFaceDown; }
    
    return UIDeviceOrientationUnknown;
}

+ (void)setOrientation:(UIDeviceOrientation)orientation
   secondsToSleepAfter:(NSTimeInterval)secondsToSleepAfter {
    [XCUIDevice sharedDevice].orientation = orientation;
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, secondsToSleepAfter, false);
}

@end
