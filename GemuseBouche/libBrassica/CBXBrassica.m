
#import "CBXBrassica.h"

NSString *const kCBXBrassicaLibVersion = @"kCBXLibVersion:1.0.0";

@implementation CBXBrassica

+ (NSString *)familyName {
    return @"Brassica";
}

+ (NSArray *)vegetables {
    return @[@"cabbage", @"broccoli", @"kale", @"pak choi"];
}

@end
