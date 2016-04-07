//
//  CBGesture+Options.h
//  CBXDriver
//
//  Created by Chris Fuentes on 4/6/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBGesture.h"

@interface CBGesture (Options)
- (float)duration;
- (float)amount;
- (int)repititions;
- (NSString *)direction;
@end
