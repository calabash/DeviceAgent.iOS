//
//  QueryOptions.h
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryOptions : NSObject
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSArray *specifiers;
+ (instancetype)withJSON:(NSDictionary *)json
      requiredSpecifiers:(NSArray *)requiredSpecifiers
      optionalSpecifiers:(NSArray *)optionalSpecifiers
            requiredKeys:(NSArray *)requiredKeys
            optionalKeys:(NSString *)optionalKeys
       collectWarningsIn:(NSMutableArray<NSString *> *)warnings;
@end
