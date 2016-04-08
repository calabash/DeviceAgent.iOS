
#import "InvalidArgumentException.h"
#import "Testmanagerd.h"
#import "EnterText.h"

@implementation EnterText

+ (NSString *)name { return @"enter_text"; }

+ (Gesture *)executeWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion {
    NSMutableDictionary *j = [json mutableCopy];
    
    if (![[j allKeys] containsObject:CB_STRING_KEY]) {
        @throw [InvalidArgumentException withFormat:@"Missing required key 'string'"];
    }
    
    NSString *string = j[CB_STRING_KEY];
    [j removeObjectForKey:CB_STRING_KEY];
    
    if ([[j allKeys] count] > 0) {
        @throw [InvalidArgumentException withFormat:@"Found unsupported keys: %@", [j allKeys]];
    }
    
    [[Testmanagerd get] _XCT_sendString:string completion:^(NSError *e) {
        completion(e);
    }];
    
    return nil;
}

@end
