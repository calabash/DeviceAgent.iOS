/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "SpringBoard.h"
#import "SpringBoardAlert.h"
#import "SpringBoardAlerts.h"
#import "XCUIElement.h"
#import "XCElementSnapshot.h"
#import "GestureFactory.h"
#import "XCUIElement+WebDriverAttributes.h"
#import "CBXException.h"

@interface SpringBoard ()

- (BOOL)shouldDismissAlertsAutomatically;
- (BOOL)tapAlertButtonWithFrame:(CGRect)frame;
- (SpringBoardAlertHandlerResult)handleAlert;

@end

@implementation SpringBoard

- (instancetype)initPrivateWithPath:(id)arg1 bundleID:(id)arg2 {
    self = [super initPrivateWithPath:arg1 bundleID:arg2];
    if (self) {
        // Please keep.  There were implementations that required ivars.
        // Interacting with SpringBoard is a WIP.
    }
    return self;
}

+ (instancetype)application {
    static SpringBoard *_springBoard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _springBoard = [[SpringBoard alloc]
                        initPrivateWithPath:nil
                        bundleID:@"com.apple.springboard"];
        [[_springBoard applicationQuery] elementBoundByIndex:0];
        [_springBoard resolve];
    });
    return _springBoard;
}

- (XCUIElement *)queryForAlert {
    @synchronized (self) {
        XCUIElement *alert = nil;

        XCUIElementQuery *query = [self descendantsMatchingType:XCUIElementTypeAlert];
        NSArray <XCUIElement *> *elements = [query allElementsBoundByIndex];

        if ([elements count] != 0) {
            alert = elements[0];
        }
        return alert;
    }
}

- (BOOL)shouldDismissAlertsAutomatically {
    // TODO Provide a launch argument or route to disable the automatic dismiss.
    return YES;
}

- (SpringBoardAlertHandlerResult)handleAlertsOrThrow {
    if (![self shouldDismissAlertsAutomatically]) {
        return SpringBoardAlertHandlerIgnoringAlerts;
    }

    @synchronized (self) {
        SpringBoardAlertHandlerResult result = SpringBoardAlertHandlerNoAlert;

        // There are fewer than 20 kinds of SpringBoard alerts.
        NSUInteger try = 0, maxTries = 20;

        result = [self handleAlert];

        while(result != SpringBoardAlertHandlerNoAlert &&
              result != SpringBoardAlertHandlerIgnoringAlerts &&
              try < maxTries) {
            result = [self handleAlert];
            if (result == SpringBoardAlertHandlerUnrecognizedAlert) {
                break;
            }
            ++try;
        }

        if (try == maxTries || result == SpringBoardAlertHandlerUnrecognizedAlert) {
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

        // In the case where multiple alerts are encountered and all the alerts
        // are dismissed, 'current" will be SpringBoardAlertHandlerNoAlert.  The
        // caller might be interested to know that an alert was dismissed.
        if (result == SpringBoardAlertHandlerDismissedAlert ||
            result == SpringBoardAlertHandlerIgnoringAlerts) {
            return result;
        }
        return SpringBoardAlertHandlerNoAlert;
    }
}

- (SpringBoardAlertHandlerResult)handleAlert {
    @synchronized (self) {
        XCUIElement *alert = [self queryForAlert];
        
        // Alert is now gone? It can happen.
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
        NSString *mark = springBoardAlert.defaultDismissButtonMark;
        
        // Alert is now gone? It can happen...
        if (!alert.exists) {
            return SpringBoardAlertHandlerNoAlert;
        }
        
        button = alert.buttons[mark];
        [button resolve];
        
        // A button with the expected title does not exist.
        // It probably changed after an iOS update.
        if (!button.exists) {
            button = nil;
        }
        
        // Use the default accept/deny button.
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
                button = buttons.lastObject;
            } else {
                button = buttons.firstObject;
            }
        }
        
        if ([self tapAlertButton:button]) {
            return SpringBoardAlertHandlerDismissedAlert;
        } else {
            return SpringBoardAlertHandlerNoAlert;
        }
    }
}

- (BOOL)tapAlertButtonWithFrame:(CGRect)frame {
    @synchronized (self) {

        // There are cases where we cannot find a hitpoint.
        if (frame.origin.x <= 0.0 || frame.origin.y <= 0.0) {
            return NO;
        }

        // This could also be done with [button tap].
        //
        // However, the system seems more stable if we use our touch gesture.
        CGFloat x = CGRectGetMinX(frame) + (CGRectGetWidth(frame)/2.0);
        CGFloat y = CGRectGetMinY(frame) + (CGRectGetHeight(frame)/2.0);

        NSDictionary *body =
        @{
          @"gesture" : @"touch",
          @"options" : @{},
          @"specifiers" : @{@"coordinate" : @{ @"x" : @(x), @"y" : @(y)}}
          };

        __block BOOL success = NO;
        [GestureFactory executeGestureWithJSON:body completion:^(NSError *e) {
            success = !e;
        }];

        if (success) {
            // There is one alert that is very problematic:
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
            // would open.  Sleeping after the dismiss definitely reduced the
            // frequency of crashes - they still happened.
            //
            // The AUT crash was caused by IImagePickerViewController which has a
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
            NSTimeInterval interval = 1.0;
            NSDate *until = [[NSDate date] dateByAddingTimeInterval:interval];
            [[NSRunLoop mainRunLoop] runUntilDate:until];
        }
        return success;
    }
}

- (BOOL)tapAlertButton:(XCUIElement *)button {
    [button resolve];
    
    if (!button.exists) {
        return SpringBoardDismissAlertNoMatchingButton;
    }
    
    // There are cases where the button does not respond to wdFrame.
    CGRect frame;
    if (![button respondsToSelector:@selector(wdFrame)]) {
        frame = [button frame];
    } else {
        frame = [button wdFrame];
    }
    
    return [self tapAlertButtonWithFrame:frame];
}

- (SpringBoardDismissAlertResult)dismissAlertByTappingButtonWithTitle:(NSString *)title {
    @synchronized (self) {
        XCUIElement *alert = [self queryForAlert];

        if (!alert) {
            return SpringBoardDismissAlertNoAlert;
        } else {
            if ([self tapAlertButton:alert.buttons[title]]) {
                return SpringBoardDismissAlertDismissedAlert;
            } else {
                return SpringBoardDismissAlertDismissTouchFailed;
            }
        }
    }
}

@end
