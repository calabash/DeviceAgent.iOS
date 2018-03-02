
#import "QueryFactory.h"
#import "CoordinateQuery.h"
#import "QueryConfiguration.h"

@implementation QueryFactory
+ (Query *)queryWithQueryConfiguration:(QueryConfiguration *_Nonnull)queryConfig {
    if ([queryConfig isCoordinateQuery]) {
        return [CoordinateQuery withQueryConfiguration:queryConfig];
    } else {
        return [Query withQueryConfiguration:queryConfig];
    }
}
@end
