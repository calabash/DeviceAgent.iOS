
#import <XCTest/XCTest.h>
#import "Screenshotter.h"

@implementation Screenshotter

+ (void)screenshotWithTitle:(NSString *)format, ... {

  NSString *title = nil;
  va_list args;
  va_start(args, format);
  title = [[NSString alloc] initWithFormat:format arguments:args];
  va_end(args);

  [XCTContext
   runActivityNamed:title
   block:^(id<XCTActivity>  _Nonnull activity) {
     XCUIScreenshot *screenshot = [[XCUIScreen mainScreen] screenshot];
     XCTAttachment *attachment;
     attachment = [XCTAttachment attachmentWithScreenshot:screenshot];
     [attachment setLifetime:XCTAttachmentLifetimeKeepAlways];
     [activity addAttachment:attachment];
   }];
}

@end
