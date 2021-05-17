/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "SpringBoard.h"
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "Application.h"
#import "SpringBoardAlert.h"
#import "SpringBoardAlerts.h"
#import "XCElementSnapshot.h"
#import "GestureFactory.h"
#import "CBXException.h"
#import <UIKit/UIKit.h>
#import "CBXConstants.h"
#import "XCTest+CBXAdditions.h"
#import "CBXMachClock.h"

typedef enum : NSUInteger {
    SpringBoardAlertHandlerIgnoringAlerts = 0,
    SpringBoardAlertHandlerNoAlert,
    SpringBoardAlertHandlerDismissedAlert,
    SpringBoardAlertHandlerUnrecognizedAlert
} SpringBoardAlertHandlerResult;

@interface SpringBoard ()

- (BOOL)shouldDismissAlertsAutomatically;
- (SpringBoardAlertHandlerResult)handleAlert;
- (BOOL)tapAlertButton:(XCUIElement *)alertButton;
- (CGPoint)hitPointForAlertButton:(XCUIElement *)alertButton;
- (CGPoint)pointByTranslatingPoint:(CGPoint)point;

@end

@implementation SpringBoard

- (instancetype)initWithBundleIdentifier:(NSString *)bundleIdentifier {
    self = [super initWithBundleIdentifier:bundleIdentifier];
    if (self) {
        _shouldDismissAlertsAutomatically = YES;
    }
    return self;
}

+ (instancetype)application {
    static SpringBoard *_springBoard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _springBoard = [[SpringBoard alloc]
                        initWithBundleIdentifier:@"com.apple.springboard"];

        [XCUIApplication cbxResolveApplication:_springBoard];
    });
    return _springBoard;
}

- (XCUIElement *)queryForAlert {
    @synchronized (self) {
        XCUIElement *alert = nil;
            
        // Collect timing info
        NSTimeInterval startTime = [[CBXMachClock sharedClock] absoluteTime];
        
        XCUIElementQuery *query = [self descendantsMatchingType:XCUIElementTypeAlert];
        NSArray <XCUIElement *> *elements = [query allElementsBoundByIndex];

        if ([elements count] != 0) {
            alert = elements[0];
        }

        NSTimeInterval elapsedSeconds = [[CBXMachClock sharedClock] absoluteTime] - startTime;
        DDLogDebug(@"SpringBoard.queryForAlert took %@ seconds", @(elapsedSeconds));

        return alert;
    }
}

- (void)handleAlertsOrThrow {

    @synchronized (self) {

        if (![self shouldDismissAlertsAutomatically]) { return; }

        SpringBoardAlertHandlerResult current = SpringBoardAlertHandlerNoAlert;

        // There are fewer than 20 kinds of SpringBoard alerts.
        NSUInteger maxTries = 20;
        NSUInteger try = 0;

        current = [self handleAlert];

        while(current != SpringBoardAlertHandlerNoAlert && try < maxTries) {
            current = [self handleAlert];
            if (current == SpringBoardAlertHandlerUnrecognizedAlert) {
                break;
            }
            try = try + 1;
        }

        if (try == maxTries || current == SpringBoardAlertHandlerUnrecognizedAlert) {
            XCUIElement *alert = nil;
            NSString *alertTitle = nil;
            NSArray *alertButtonTitles = @[];

            alert = [self queryForAlert];

            if (alert && alert.exists) {
                alertTitle = alert.label;
                XCUIElementQuery *query = [alert descendantsMatchingType:XCUIElementTypeButton];
                NSArray<XCUIElement *> *buttons = [query allElementsBoundByIndex];

                NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:buttons.count];

                for(XCUIElement *button in buttons) {
                    if (button.exists) {
                        NSString *name = button.label;
                        if (name) {
                            [mutable addObject:name];
                        }
                    }
                }
                alertButtonTitles = [NSArray arrayWithArray:mutable];
            }

            NSString *message;
            message = @"A SpringBoard alert is blocking test execution and it cannot be dismissed.";
            @throw [CBXException withMessage:message
                                    userInfo:@{
                                               @"title" : alertTitle ?: [NSNull null],
                                               @"buttons" : alertButtonTitles,
                                               @"tries" : @(maxTries)
                                               }];
        }
    }
}

- (XCUIElement *)findDismissButtonOnAlert: (XCUIElement *) alert marks: (NSArray *) marks {
    XCUIElement *button = nil;
    for (NSString *mark in marks) {
        button = alert.buttons[mark];

        // Resolve before asking if the button exists.
        [button cbx_resolve];

        if (button && button.exists) {
            return button;
        }
    }
    
    return button;
}

// If something goes wrong, SpringBoardAlertHandlerNoAlert is returned.
// This method is not protected by a lock!  It should only be called by
// handleAlertsOrThrow
- (SpringBoardAlertHandlerResult)handleAlert {

    XCUIElement *alert = [self queryForAlert];

    // There is not alert.
    if (!alert || !alert.exists) {
        return SpringBoardAlertHandlerNoAlert;
    }

    // .label is the title for English and German.  Hopefully for others too.
    NSString *title = alert.label;
    SpringBoardAlert *springBoardAlert;
    springBoardAlert = [[SpringBoardAlerts shared] alertMatchingTitle:title];

    // We don't know about this alert.
    if (!springBoardAlert) {
        return SpringBoardAlertHandlerUnrecognizedAlert;
    }

    XCUIElement *button = nil;
    NSArray *marks = springBoardAlert.defaultDismissButtonMarks;

    // Alert is now gone? It can happen...
    if (!alert.exists) {
        return SpringBoardAlertHandlerNoAlert;
    }
        
    button = [self findDismissButtonOnAlert: alert marks: marks];

    // A button with the expected title does not exist.
    // It probably changed after an iOS update.
    if (!button || !button.exists) {
        button = nil;
    }

    // Use the default accept/deny button, but only if we recognize this alert.
    if (!button) {

        if (!alert.exists) {
            return SpringBoardAlertHandlerNoAlert;
        }

        XCUIElementQuery *query = [alert descendantsMatchingType:XCUIElementTypeButton];
        NSArray<XCUIElement *> *buttons = [query allElementsBoundByIndex];

        if ([buttons count] == 0) {
            return SpringBoardAlertHandlerNoAlert;
        }

        if (springBoardAlert.shouldAccept) {
            switch ([buttons count]) {

                case 1: {
                    // Single button alert
                    button = buttons[0];
                    break;
                }
                case 2: {
                    // Two button alert
                    button = buttons[1];
                    break;
                }
                case 3: {
                    // Three button alert
                    // Allow Location Always notification started popping this
                    // alert in iOS 11.
                    button = buttons[1];
                    break;
                }

                default: {
                    button = buttons.lastObject;
                    break;
                }

            }

        } else {
            button = buttons.firstObject;
        }
    }

    // Resolve before asking if the button exists.
    [button cbx_resolve];

    if (!button || !button.exists) {
        return SpringBoardAlertHandlerNoAlert;
    }

    BOOL success = [self tapAlertButton:button];

    if (!success) {
        return SpringBoardAlertHandlerNoAlert;
    }

    return SpringBoardAlertHandlerDismissedAlert;
}

- (SpringBoardDismissAlertResult)dismissAlertByTappingButtonWithTitle:(NSString *)title {
    @synchronized (self) {
        XCUIElement *alert = [self queryForAlert];

        if (!alert) {
            return SpringBoardDismissAlertNoAlert;
        } else {
            XCUIElement *button = alert.buttons[title];
            [button cbx_resolve];

            if (!button || !button.exists) {
                return SpringBoardDismissAlertNoMatchingButton;
            }

            BOOL success = [self tapAlertButton:button];

            SpringBoardDismissAlertResult result;
            if (success) {
                result = SpringBoardDismissAlertDismissedAlert;
            } else {
                result = SpringBoardDismissAlertDismissTouchFailed;
            }

            return result;
        }
    }
}

- (BOOL)tapAlertButton:(XCUIElement *)alertButton {
    @synchronized (self) {
        [alertButton cbx_resolve];
        CGPoint hitPoint = [self hitPointForAlertButton:alertButton];

        if (hitPoint.x < 0 || hitPoint.y < 0) {
           return NO;
        }

        NSDictionary *body =
        @{
          @"gesture" : @"touch",
          @"options" : @{},
          @"specifiers" : @{@"coordinate" :
                                @{ @"x" : @(hitPoint.x),
                                   @"y" : @(hitPoint.y)
                                   }
                            }
          };

        __block BOOL success = YES;
        [GestureFactory executeGestureWithJSON:body completion:^(NSError *error) {
            if (error) {
                DDLogError(@"Error dismissing alert: %@", error.localizedDescription);
                success = NO;
            }
        }];

        // Let the main RunLoop progress before executing more queries or
        // gestures.  It is possible that a failed touch will succeed on the
        // next pass.
        //
        // There is one alert workflow that is very problematic:
        //
        // PhotoRoll
        //
        // 1. Trigger the alert
        // 2. Alert appears
        // 3. Alert is automatically dismissed
        // 3. Photo Roll is animated on behind the alert
        // 4. Next gesture or query triggers an alert query
        //
        // The AXServer crashes, then the AUT crashes, and then DeviceAgent
        // performs the gesture or query on the SpringBoard.  For example, if
        // the gesture was a touch to Cancel the Photo Roll, the Newstand app
        // would open because that is the App Icon at the position of the
        // of the Cancel touch.  Sleeping after the dismiss definitely
        // reduced the frequency of crashes - they still happened.
        //
        // The AUT crash was caused by UIImagePickerViewController which has a
        // history of crashing in situations like this.
        //
        // After days device and simulator testing, I settled on 1.0 second.
        // If there is no sleep or the sleep is too short the AXServer can
        // disconnect which can cause the DeviceAgent to fail: crashes,
        // TestPlan exits, etc.
        //
        // We will need to see if this value needs to be adjusted for different
        // environments e.g. CI, XTC, Simulators, etc.
        //
        // We prefer stability over speed.
        CFTimeInterval interval = 1.0;
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, interval, false);

        return success;
   }
}

- (CGPoint)hitPointForAlertButton:(XCUIElement *)alertButton {
    [alertButton cbx_resolve];

//    XCElementSnapshot *snapshot = alertButton.lastSnapshot;
//
//    NSValue *hitPointValue = snapshot.suggestedHitpoints.firstObject;
//
    CGPoint hitPoint;
//    if (!hitPointValue) {
        XCUICoordinate *coordinate;
        coordinate = [alertButton coordinateWithNormalizedOffset:CGVectorMake(0.5, 0.5)];
        hitPoint = coordinate.screenPoint;
//    } else {
//        hitPoint = hitPointValue.CGPointValue;
//    }

    return [self pointByTranslatingPoint:hitPoint];
}

- (CGPoint)pointByTranslatingPoint:(CGPoint)point {
    CGPoint translated = point;
    CGSize appSize = self.frame.size;
    UIInterfaceOrientation orientation = self.interfaceOrientation;

    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: {
            translated = CGPointMake(appSize.width - point.x,
                                     appSize.height - point.y);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            translated = CGPointMake(appSize.height - point.y, point.x);
            break;
        }
        case UIInterfaceOrientationLandscapeRight: {
            translated = CGPointMake(point.y, appSize.width - point.x);
            break;
        }

        default: { break; }
    }

    return translated;
}

@end
