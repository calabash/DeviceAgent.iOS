
#import <Foundation/Foundation.h>

/*
 Methods for adding labelled steps to tests.  Labeling automatically takes
 a screenshot and attaches it to the test report.
*/

@interface ACTLabel : NSObject

/*
 Objective-C
*/
+ (void)label:(NSString *)fmt, ...;
#define act_label(...) [ACTLabel label: __VA_ARGS__]

/*
 Swift or Objective-C
 */
+ (void)labelStep:(NSString *)msg;
+ (void)labelStep:(NSString *)fmt args:(va_list)args;

@end
