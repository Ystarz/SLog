//
//  SLogManager.m
//  im_core_ios
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SLogManager.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
//#import "KKLog.h"
//old
#define LOG_SAVE_TIMEINTERVAL 60*60 //单位s
//new
#define MAX_LOG_FILE_COUNT 1000

//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
static DDLogLevel ddLogLevel;
@interface SLogManager()
@property(strong,nonatomic)NSTimer*timer;
@end



@implementation SLogManager
+ (instancetype)sharedInstance
{
    static SLogManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    }
    return self;
}
// 程序Crash后的处理函数
void uncaughtExceptionHandler(NSException *exception)
{
    //[KKLog logCrash:exception];
    [[SLogManager sharedInstance]logCrash:exception];
}

+(void)startWork{
    [SLogManager startWorkOnLogMode:LogModeDebug ifCache:YES];
}

+(void)startWorkOnLogMode:(LogMode)type{
    [SLogManager startWorkOnLogMode:type ifCache:YES];
}
+(void)startWorkOnLogMode:(LogMode)type ifCache:(bool)localCache{
    //[[SLogManager sharedInstance]setCacheTime:60 * 60 * 24*30*6];
    [SLogManager startWorkOnLogMode:type ifCache:localCache cacheTime:60 * 60 * 24*30*6];
}

+(void)startWorkOnLogMode:(LogMode)type ifCache:(bool)localCache cacheTime:(int)time{
    [[SLogManager sharedInstance]setCacheTime:time];
    [[SLogManager sharedInstance]setLogMode:type];
    switch (type) {
        case  LogModeDebug:
            ddLogLevel=DDLogLevelAll;
            break;
        case LogModeRealease:
            ddLogLevel=DDLogLevelInfo;
            break;
        case LogModeNone:
            ddLogLevel=DDLogLevelOff;
            break;
    }
    [[SLogManager sharedInstance]setIsLocalCache:localCache];
    [[SLogManager sharedInstance]start];
}

#pragma mark 内部实现
-(void)start{
     //[DDLog addLogger:[DDTTYLogger sharedInstance]];
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    // iOS Simulator
    // iOS device
    if (@available(iOS 10.0, *)) {
        [DDLog addLogger:[DDOSLogger sharedInstance]];
    } else {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        // Fallback on earlier versions
    }
#elif TARGET_OS_MAC
    if (@available(macOS 10.12, *)) {
        [DDLog addLogger:[DDOSLogger sharedInstance]];
    } else {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        // Fallback on earlier versions
    }
#endif
    
    if (self.isLocalCache) {
        // 开始保存日志文件
        //[self saveLogToLocal];
        [self saveLogToLocalWithDD];
    }
//#if !DEBUG
//    // 开始保存日志文件
//   [self saveLogToLocal];
//    //定义计时器
//    self.timer=[NSTimer timerWithTimeInterval:LOG_SAVE_TIMEINTERVAL target:self selector:@selector(timeUpdate) userInfo:nil repeats:true];
//    //开启计时器
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//#endif
}

-(void)timeUpdate{
    [self saveLogToLocal];
}

- (void)saveLogToLocal
{
    //销毁旧的计时器
    if (self.timer) {
        [self.timer invalidate];
    }
    //定义计时器
    self.timer=[NSTimer timerWithTimeInterval:LOG_SAVE_TIMEINTERVAL target:self selector:@selector(timeUpdate) userInfo:nil repeats:true];
    //开启计时器
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
   NSString *documentDirectory = [self createLogDir];
    if (!documentDirectory) {
        OCLOG(@"日志目录创建失败/fail to create log dir");
        return;
    }
    else{
        NSString*timeString= [STimeTool getNowTime:nil];
        NSString *fileName = [NSString stringWithFormat:@"%@.log",timeString];//注意不是NSData!
        NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
        // 将log输入到文件
        freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding],"a+", stdout);
        freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding],"a+", stderr);
        
        //fopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], stdout);
//        freopen("CON","r",stdin);
//        freopen("CON","w",stdout);
    }
}

- (void)saveLogToLocalWithDD
{
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = self.cacheTime;//60 * 60 * 24*30*6; // half-year rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = MAX_LOG_FILE_COUNT;
    [DDLog addLogger:fileLogger];
}

-(void)logCrash:(NSException *)exception{
    if (nil == exception)
    {
        return;
    }
#ifdef DEBUG
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
#endif


    NSString *content = [[NSString stringWithFormat:@"CRASH: %@\n", exception] stringByAppendingString:[NSString stringWithFormat:@"Stack Trace: %@\n", [exception callStackSymbols]]];
    
    //OCLOG(@"%@",content);
    DDLogError(@"%@",content);
   //[content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}


-(NSString*)createLogDir{
     NSString *documentDirectory = @"";
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    documentDirectory =NSHomeDirectory();
    documentDirectory=[documentDirectory stringByAppendingPathComponent:@"Documents"];
#elif TARGET_OS_MAC
    documentDirectory = [[NSBundle mainBundle].bundlePath stringByDeletingLastPathComponent];
#endif
    if (![NSString isNull:self.rootPath]) {
        documentDirectory=self.rootPath;
    }
    NSString *logDir=[documentDirectory stringByAppendingPathComponent:@"log"];
    if (![SFileTool isDirExist:logDir]) {
        [SFileTool createDir:logDir];
    }
    if ([SFileTool isDirExist:logDir]) {
        return logDir;
    }
    return nil;
}

-(void)log:(NSString*)msg{
    if (self.logMode==LogModeNone) {
        return;
    }
    msg=[self fixMsg:msg type:LogTypeNormal];
//    NSLog(@"%@",msg);
    DDLogInfo(@"%@",msg);
    if (self.logDelegate!=nil) {
        if ([self.logDelegate respondsToSelector:@selector(onLog:)]) {
             [self.logDelegate onLog:msg];
        }
       
    }
}

-(void)logD:(NSString*)msg{
    if (self.logMode!=LogModeDebug) {
        return;
    }
    msg=[self fixMsg:msg type:LogTypeDebug];
//    NSLog(@"%@",msg);
    DDLogDebug(@"%@",msg);
    if (self.logDelegate!=nil) {
        //OCLOG(@"You0");
        if ([self.logDelegate respondsToSelector:@selector(onLogD:)]) {
            //OCLOG(@"You1");
            [self.logDelegate onLogD:msg];
        }
    }
}

-(void)logI:(NSString*)msg{
    if (self.logMode==LogModeNone) {
        return;
    }
    msg=[self fixMsg:msg type:LogTypeInfo];
//    NSLog(@"%@",msg);
    DDLogInfo(@"%@",msg);
    if (self.logDelegate!=nil) {
        if ([self.logDelegate respondsToSelector:@selector(onLogI:)]) {
            [self.logDelegate onLogI:msg];
        }
        
    }
}

-(void)logE:(NSString*)msg{
    if (self.logMode==LogModeNone) {
        return;
    }
    msg=[self fixMsg:msg type:LogTypeError];
//    NSLog(@"%@",msg);
    DDLogWarn(@"%@",msg);
    if (self.logDelegate!=nil) {
        if ([self.logDelegate respondsToSelector:@selector(onLogE:)]) {
            [self.logDelegate onLogE:msg];
        }
        
    }
}


-(NSString*)fixMsg:(NSString*)msg type:(LogType)type{
    NSString *time=[STimeTool getNowTime:nil];
    NSString*logTypeStr=@"N";
    switch (type) {
        case LogTypeNormal:
            logTypeStr=@"N";
            break;
        case LogTypeDebug:
            logTypeStr=@"D";
            break;
        case LogTypeInfo:
            logTypeStr=@"I";
            break;
        case LogTypeError:
            logTypeStr=@"E";
            break;
        default:
            break;
    }
    return NSStringFormat(@"[%@][%@] %@",logTypeStr,time,msg);
}
@end
