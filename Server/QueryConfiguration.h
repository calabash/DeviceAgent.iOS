//
//  QueryOptions.h
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryConfiguration : NSObject

/*
    Specifiers are keys which help specify an element in the application's view hierarchy.
    Examples would include 'coordinate', 'text', 'id', etc.
 */
@property (nonatomic, strong) NSMutableArray *specifiers;

/*
    Convenience indexing into raw json object
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*
    Creates a QueryConfiguration object and validates the json inputs against
    required/optional specifiers.
 */
+ (instancetype)withJSON:(NSDictionary *)json
      requiredSpecifiers:(NSArray <NSString *> *)requiredSpecifiers
      optionalSpecifiers:(NSArray <NSString *> *)optionalSpecifiers;

/*
    Creates a QueryConfiguraiton object without any validated input
 */
+ (instancetype)withJSON:(NSDictionary *)json;

/*
    Debuging / error logging
 */
- (NSDictionary *)toDictionary;
@end
