//
//  DDCMDFileLogger.m
//  CMD-SLogTest
//
//  Created by SSS on 2019/8/26.
//  Copyright © 2019 SSS. All rights reserved.
//

#import "DDCMDFileLogger.h"
@implementation DDLogCMDFileManagerDefault
- (NSString *)defaultLogsDirectory {
    
#if TARGET_OS_IPHONE
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"Logs"];
#else
//    NSString *appName = [[NSProcessInfo processInfo] processName];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *basePath = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
//    NSString *logsDirectory = [[basePath stringByAppendingPathComponent:@"Logs"] stringByAppendingPathComponent:appName];
    NSString *logsDirectory =[[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:@"Logs"]; //NSHomeDirectory();
#endif
    
    return logsDirectory;
}

- (NSString *)newLogFileName {
    
    NSDateFormatter *dateFormatter = [self logFileDateFormatter];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@.log", formattedDate];
}

// if you change formatter, then change sortedLogFileInfos method also accordingly
- (NSDateFormatter *)logFileDateFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSString *dateFormat = @"yyyy'-'MM'-'dd'--'HH'-'mm'-'ss'-'SSS'";
    NSString *key = [NSString stringWithFormat:@"logFileDateFormatter.%@", dateFormat];
    NSDateFormatter *dateFormatter = dictionary[key];
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:dateFormat];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        dictionary[key] = dateFormatter;
    }
    
    return dateFormatter;
}
@end


@implementation DDCMDFileLogger

- (instancetype)init {
    DDLogCMDFileManagerDefault *defaultLogFileManager = [[DDLogCMDFileManagerDefault alloc] init];
    return [self initWithLogFileManager:defaultLogFileManager completionQueue:nil];
}
@end
