//
//  SErrorFileLogger.m
//  SLog
//
//  Created by SSS on 2019/8/29.
//  Copyright © 2019 SSS. All rights reserved.
//

#import "SErrorFileLogger.h"
#import <SDataTools/SDataTools.h>

#define LOG_DIR @"errLogs"

@implementation SErrorFileManagerDefault
- (NSString *)defaultLogsDirectory {
    
#if TARGET_OS_IPHONE
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:LOG_DIR];
#else
    //    NSString *appName = [[NSProcessInfo processInfo] processName];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    //    NSString *basePath = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
    //    NSString *logsDirectory = [[basePath stringByAppendingPathComponent:@"Logs"] stringByAppendingPathComponent:appName];
    
    NSString *logsDirectory =[[[[NSBundle mainBundle] bundlePath]stringByDeletingLastPathComponent] stringByAppendingPathComponent:LOG_DIR]; //NSHomeDirectory();
    if ([self getIsCMD]) {
        logsDirectory =[[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:LOG_DIR];
    }
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

#pragma mark 内部方法
//临时写在这
-(bool)getIsCMD{
    bool isCMD=false;
    NSString*bId=[NSBundle mainBundle].bundleIdentifier;
    if ([NSString isNull:bId]||[bId isEqualToString:@"$(PRODUCT_BUNDLE_IDENTIFIER)"]) {
        isCMD=true;
    }
    return isCMD;
}
@end


@implementation SErrorFileLogger

- (instancetype)init {
    SErrorFileManagerDefault *defaultLogFileManager = [[SErrorFileManagerDefault alloc] init];
    return [self initWithLogFileManager:defaultLogFileManager completionQueue:nil];
}
@end
