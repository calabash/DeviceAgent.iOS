
#ifndef CBXTypedefs_h
#define CBXTypedefs_h

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(NSError *e);
typedef void (^Block)(void);
typedef void (^AsyncBlock)(BOOL *setToTrueWhenDone, NSError **err);

#endif /* CBXTypedefs_h */
