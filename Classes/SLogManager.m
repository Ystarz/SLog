//
//  LogManager.m
//  im_core_ios
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SLogManager.h"
//#import "KKLog.h"

#define LOG_SAVE_TIMEINTERVAL 60*60 //单位s

@interface LogManager()
@property(strong,nonatomic)NSTimer*timer;
@end


//#define KKLOG
@implementation LogManager
+ (instancetype)sharedInstance
{
    static LogManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


+(void)startWork{
    [[LogManager sharedInstance]start];
}

#pragma mark 内部实现
-(void)start{
#if !DEBUG
    // 开始保存日志文件
   [self saveLogToLocal];
    //定义计时器
    self.timer=[NSTimer timerWithTimeInterval:LOG_SAVE_TIMEINTERVAL target:self selector:@selector(timeUpdate) userInfo:nil repeats:true];
    //开启计时器
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
#endif
}

-(void)timeUpdate{
    [self saveLogToLocal];
}

- (void)saveLogToLocal
{
   NSString *documentDirectory = [self createLogDir];
    if (!documentDirectory) {
        OCLOG(@"日志目录创建失败");
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
    NSString *documentDirectory = [[NSBundle mainBundle].bundlePath stringByDeletingLastPathComponent];
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
    //[KKLog logI:msg];
    //KKLogI(msg);
    msg=[self fixMsg:msg];
    if (self.logDelegate!=nil) {
        if ([self.logDelegate respondsToSelector:@selector(onLog:)]) {
             [self.logDelegate onLog:msg];
        }
       
    }
}

-(void)logD:(NSString*)msg{
    //[KKLog logD:msg];
    //KKLogD(msg);
    msg=[self fixMsg:msg];
    if (self.logDelegate!=nil) {
        //OCLOG(@"You0");
        if ([self.logDelegate respondsToSelector:@selector(onLogD:)]) {
            //OCLOG(@"You1");
            [self.logDelegate onLogD:msg];
        }
    }
}


-(NSString*)fixMsg:(NSString*)msg{
    NSString *time=[STimeTool getNowTime:nil];
    return NSStringFormat(@"[%@]-%@",time,msg);
}
@end
