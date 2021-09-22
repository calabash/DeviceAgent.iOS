
#import "CBXLogging.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <libkern/OSAtomic.h>
#import <CocoaLumberjack/DDOSLogger.h>
#import <stdatomic.h>

#pragma mark - CBXLogFileManager

static NSString *const IDMLogFormatterDateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
static NSString *const IDMLogFormatterDateFormatterKey = @"sh.calaba-IDMLogFormatter-NSDateFormatter";

@interface CBXLogFormatter : NSObject <DDLogFormatter>  {
  atomic_int_fast32_t atomicLoggerCount;
  NSDateFormatter *threadUnsafeDateFormatter;
}

- (NSString *)stringFromDate:(NSDate *)date;

@end


@implementation CBXLogFormatter

- (NSString *)stringFromDate:(NSDate *)date {
  atomic_int_fast32_t loggerCount = atomic_fetch_add_explicit(&atomicLoggerCount, 0, memory_order_relaxed);

  if (loggerCount <= 1) {
    // Single-threaded mode.

    if (!threadUnsafeDateFormatter) {
      threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
      [threadUnsafeDateFormatter setDateFormat:IDMLogFormatterDateFormat];
    }

    return [threadUnsafeDateFormatter stringFromDate:date];
  } else {
    // Multi-threaded mode.
    // NSDateFormatter is NOT thread-safe.
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[IDMLogFormatterDateFormatterKey];

    if (dateFormatter == nil) {
      dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:IDMLogFormatterDateFormat];

      threadDictionary[IDMLogFormatterDateFormatterKey] = dateFormatter;
    }

    return [dateFormatter stringFromDate:date];
  }
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
  NSString *logLevel;
  switch (logMessage.flag) {
    case DDLogFlagError    : logLevel = @"ERROR"; break;
    case DDLogFlagWarning  : logLevel = @" WARN"; break;
    case DDLogFlagInfo     : logLevel = @ "INFO"; break;
    case DDLogFlagDebug    : logLevel = @"DEBUG"; break;
    default                : logLevel = @"DEBUG"; break;
  }

  NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];
  NSString *logMsg = logMessage->_message;

  NSString *filenameAndNumber = [NSString stringWithFormat:@"%@:%@",
                                 logMessage.fileName, @(logMessage.line)];
  return [NSString stringWithFormat:@"%@ %@ %@ | %@",
          dateAndTime,
          logLevel,
          filenameAndNumber,
          logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
  atomic_fetch_add_explicit(&atomicLoggerCount, 1, memory_order_relaxed);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
  atomic_fetch_sub_explicit(&atomicLoggerCount, 1, memory_order_relaxed);
}

@end

#pragma mark - CBXDeviceManagerLogging

@implementation CBXLogging

+ (void)startLumberjackLogging {

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // Xcode Console Logging - maybe enable this logger at runtime if we are
    // running from within the Xcode IDE or with xcodebuild test.
    [[DDTTYLogger sharedInstance] setLogFormatter:[CBXLogFormatter new]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    // Apple System Logger
    [[DDOSLogger sharedInstance] setLogFormatter:[CBXLogFormatter new]];
    [DDLog addLogger:[DDOSLogger sharedInstance]];
  });
}

@end
