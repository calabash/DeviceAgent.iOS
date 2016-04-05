//
//  QueryOptions.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QueryOptions.h"

@implementation QueryOptions
+ (instancetype)withJSON:(NSDictionary *)json
      requiredSpecifiers:(NSArray *)requiredSpecifiers
      optionalSpecifiers:(NSArray *)optionalSpecifiers
            requiredKeys:(NSArray *)requiredKeys
            optionalKeys:(NSString *)optionalKeys
       collectWarningsIn:(NSMutableArray<NSString *> *)warnings {
    //TODO
}
@end
