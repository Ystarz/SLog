//
//  SLogManager.m
//  im_core_ios
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SLogManager.h"
//#import "KKLog.h"

#define LOG_SAVE_TIMEINTERVAL 60*60 //单位s

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


+(void)startWork{
    [SLogManager startWorkOnLogMode:LogModeNone ifCache:NO];
}

+(void)startWorkOnLogMode:(LogMode)type{
    [SLogManager startWorkOnLogMode:type ifCache:NO];
}
+(void)startWorkOnLogMode:(LogMode)type ifCache:(bool)localCache{
    
    [[SLogManager sharedInstance]setLogMode:type];
    [[SLogManager sharedInstance]setIsLocalCache:localCache];
    [[SLogManager sharedInstance]start];
}

#pragma mark 内部实现
-(void)start{
    if (self.isLocalCache) {
        // 开始保存日志文件
        [self saveLogToLocal];
        //定义计时器
        self.timer=[NSTimer timerWithTimeInterval:LOG_SAVE_TIMEINTERVAL target:self selector:@selector(timeUpdate) userInfo:nil repeats:true];
        //开启计时器
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
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
    }
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
    
    OCLOG(@"%@",content);
   //[content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}


-(NSString*)createLogDir{
     NSString *documentDirectory = @"";
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    documentDirectory =NSHomeDirectory();
#elif TARGET_OS_MAC
    documentDirectory = [[NSBundle mainBundle].bundlePath stringByDeletingLastPathComponent];
#endif
   
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
    NSLog(@"%@",msg);
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
    NSLog(@"%@",msg);
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
    NSLog(@"%@",msg);
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
    NSLog(@"%@",msg);
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
