//
//  ActionConfiguration.h
//  CBXDriver
//
//  Created by Chris Fuentes on 4/5/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONActionValidator.h"

@interface ActionConfiguration : NSObject
/*
 Convenience indexing into raw json object
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*
 Creates a configuration object and validates the json inputs against
 required/optional specifiers.
 */
+ (instancetype)withJSON:(NSDictionary *)json
               validator:(JSONActionValidator *)validator;

/*
 Debuging / error logging
 */
@property (nonatomic, strong) NSDictionary *raw;

@end
