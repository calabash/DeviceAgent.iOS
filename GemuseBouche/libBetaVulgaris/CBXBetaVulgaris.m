
#import "CBXBetaVulgaris.h"

NSString *const kCBXBetaVulgarisLibVersion = @"kCBXLibVersion:1.0.0";

@implementation CBXBetaVulgaris

+ (NSString *)familyName {
    return @"Beta Vulgaris";
}

+ (NSArray *)vegetables {
    return @[@"beets", @"chard"];
}

@end
