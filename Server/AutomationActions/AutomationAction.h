
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

#import <Foundation/Foundation.h>
#import "CBXProtocols.h"

/** AutomationAction is a generic (abstract) superclass for actions which 
 occur during automated user interface testing, namely Gesture and Query.
 
 @warning This class should not be instantiated directly.
 
 See also Gesture and Query
 */

@interface AutomationAction : NSObject<JSONKeyValidatorProvider>
@end
