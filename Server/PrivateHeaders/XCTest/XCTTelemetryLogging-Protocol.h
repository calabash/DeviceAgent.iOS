// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled May  6 2021 20:43:33).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//



@protocol XCTTelemetryLogging <NSObject>
- (void)flushWithCompletion:(void (^)(void))arg1;
- (void)logEventWithName:(NSString *)arg1;
- (void)logUsageOfClass:(NSString *)arg1 method:(NSString *)arg2;
- (void)logUsageOfFunction:(NSString *)arg1;
@end
