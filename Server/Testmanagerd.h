//
//  Testmanagerd.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/16/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCTestManager_ManagerInterface-Protocol.h"

@interface Testmanagerd : NSObject
+ (id<XCTestManager_ManagerInterface>)get;
@end
