//
//  CBRoute.h
//  xcuitest-server
//
//  Created by Chris Fuentes on 1/29/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "Route.h"

@interface CBRoute : Route
@property (nonatomic, strong) NSString *HTTPVerb;
+ (instancetype)get:(NSString *)path withBlock:(RequestHandler)block;
+ (instancetype)post:(NSString *)path withBlock:(RequestHandler)block;
+ (instancetype)put:(NSString *)path withBlock:(RequestHandler)block;
+ (instancetype)delete:(NSString *)path withBlock:(RequestHandler)block;
@end
 