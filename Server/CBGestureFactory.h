//
//  CBGestureFactory.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBGesture.h"

@interface CBGestureFactory : NSObject
+ (void)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion;
@end
