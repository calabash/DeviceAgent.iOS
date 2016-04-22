
#import <Foundation/Foundation.h>

/**
    
 */
@interface JSONKeyValidator : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, readonly) NSArray <NSString *> *requiredKeys;
@property (nonatomic, readonly) NSArray <NSString *> *optionalKeys;
+ (instancetype)withRequiredKeys:(NSArray <NSString *> *)requiredKeys
                    optionalKeys:(NSArray <NSString *> *)optionalKeys;
- (void)validate:(NSDictionary *)json;
NS_ASSUME_NONNULL_END
@end
