
#import "QuerySpecifier.h"
#import "CBX-XCTest-Umbrella.h"
#import "XCTest+CBXAdditions.h"
#import "CBXMacros.h"
#import "CBXException.h"

static NSDictionary<NSString *, NSString *> *escapeMap;

@implementation QuerySpecifier

+ (void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        NSArray<NSString *> *array;
        // I experimented with this set of items, but after several crashes
        // I decided to not bother with the more esoteric control characters.
        //
        // array = @[@"\0", @"\a", @"\b", @"\t", @"\n", @"\f", @"\r", @"\e", @"\'"];
        //
        // I was also worried about "%" as it is a format character, but it
        // appears it needs no special handling.
        array = @[@"\n", @"\t", @"'", @"\""];
        NSMutableDictionary<NSString *, NSString *> *mutable;
        mutable = [NSMutableDictionary dictionaryWithCapacity:[array count]];

        NSString *value;
        for (NSString *key in array) {
            value = [NSString stringWithFormat:@"\\%@", key];
            mutable[key] = value;
        }

        escapeMap = [NSDictionary dictionaryWithDictionary:mutable];
    });
}

+ (QuerySpecifierExecutionPriority)executionPriority {
    return kQuerySpecifierExecutionPriorityAny;
}

+ (NSString *)name { return nil; }

+ (NSString *)escapeString:(NSString *)string {
    NSMutableString *mutable = [[NSMutableString alloc] initWithString:string];
    [escapeMap enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        // Assume that if the string already contains the escape sequence
        // is already present, the string is already escaped.  See the
        // cucumber/features/query.feature.
        if (![mutable containsString:value]) {
            NSRange range = NSMakeRange(0, [mutable length]);
            [mutable replaceOccurrencesOfString:key
                                     withString:value
                                        options:NSCaseInsensitiveSearch
                                          range:range];
        }
    }];
    return [NSString stringWithString:mutable];
}

+ (instancetype)withValue:(id)value {
    QuerySpecifier *qs = [self new];
    qs.value = value;
    return qs;
}

- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query {
    @throw [CBXException overrideMethodInSubclassExceptionWithClass:self.class
                                                           selector:_cmd];
}

- (XCUIElementQuery *)applyToQuery:(XCUIElementQuery *)query {
    return [self applyInternal:query];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ = %@", [self.class name], self.value];
}
@end
