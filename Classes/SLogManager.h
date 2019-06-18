//
//  LogManager.h
//  im_core_ios
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDataToolsLib/STools.h>


#define LOGPREFIX @"IM"
#ifdef OC_LOGS
#define OCLOGS(fmt, ...)    \
(NSLog)(@"%@",[NSString stringWithFormat:@"%@%@",LOGPREFIX,[NSString stringWithFormat:fmt,##__VA_ARGS__]]);           \
[[LogManager sharedInstance] log:[NSString stringWithFormat:@"%@%@",LOGPREFIX,[NSString stringWithFormat:fmt,##__VA_ARGS__]]]//[[LogManager sharedInstance] log:[NSString stringWithFormat:fmt,##__VA_ARGS__]]
#else
#define OCLOGS(fmt, ...){}
#endif

#ifdef OC_LOG
#define OCLOG(fmt, ...)    \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[LogManager sharedInstance] log:[NSString stringWithFormat:fmt,##__VA_ARGS__]]
#else
#define OCLOG(fmt, ...){}
#endif

#ifdef OC_LOGD
#define OCLOGD(fmt, ...)            \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[LogManager sharedInstance] logD:[NSString stringWithFormat:fmt,##__VA_ARGS__]]

#else
#define OCLOGD(fmt, ...){}
#endif

//NSString *msg=[[NSString alloc]initWithFormat:fmt arguments:##args];
@protocol LogDelegate<NSObject>
-(void)onLogD:(NSString*) msg;
-(void)onLog:(NSString*) msg;
@end

@interface LogManager : NSObject
@property(weak,nonatomic)id<LogDelegate> logDelegate;
+(void)startWork;
+(instancetype)sharedInstance;
-(void)log:(NSString*)msg;
-(void)logD:(NSString*)msg;
-(void)logCrash:(NSException *)exception;
@end
