//
//  ScriptLauncher.m
//  XCUITestManagerDLink
//
//  Created by Chris Fuentes on 2/21/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "ScriptRunner.h"

@implementation ScriptRunner
/*
 http://stackoverflow.com/questions/412562/execute-a-terminal-command-from-a-cocoa-app/696942#696942
 */
+ (NSString *)runScript:(NSString*)scriptName {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    NSString *newpath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], scriptName];
    NSLog(@"shell script path: %@",newpath);
    NSArray *arguments = [NSArray arrayWithObjects:newpath, nil];
    [task setArguments: arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return string;
}
@end
