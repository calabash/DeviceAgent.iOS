//
//  CBGesture.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/17/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBInvalidArgumentException.h"
#import <Foundation/Foundation.h>
#import "CBElementQuery.h"
#import "Testmanagerd.h" //just so subclasses have it
#import "CBTypedefs.h"
#import "CBMacros.h"

@interface CBGesture : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CBElementQuery *query; /* Identify which element or element */

- (void)execute:(CompletionBlock)completion;
- (void)_executePrivate:(CompletionBlock)completion;
- (void)validate; //Should throw an exception if something goes wrong.
@end
