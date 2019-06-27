//
//  SLogManager.h
//  im_core_ios
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
// iOS Simulator
// iOS device
#import <SDataToolsLib/STools.h>
#elif TARGET_OS_MAC
// Other kinds of Mac OS
#import <SDataToolsLib/SDataToolsLib_Mac.h>
#else
#   error "Unknown Apple platform"
#endif


typedef enum{
    LogTypeDebug=0,
    LogTypeRealease,
    LogTypeNone,
} LogType;

//#define LOGPREFIX @"IM"
//#ifdef OC_LOGS
//#define OCLOGS(fmt, ...)    \
//(NSLog)(@"%@",[NSString stringWithFormat:@"%@%@",LOGPREFIX,[NSString stringWithFormat:fmt,##__VA_ARGS__]]);           \
//[[SLogManager sharedInstance] log:[NSString stringWithFormat:@"%@%@",LOGPREFIX,[NSString stringWithFormat:fmt,##__VA_ARGS__]]]//[[SLogManager sharedInstance] log:[NSString stringWithFormat:fmt,##__VA_ARGS__]]
//#else
//#define OCLOGS(fmt, ...){}
//#endif

//#ifdef OC_LOG
#define OCLOG(fmt, ...)    \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[SLogManager sharedInstance] log:[NSString stringWithFormat:fmt,##__VA_ARGS__]]
//#else
//#define OCLOG(fmt, ...){}
//#endif

//#ifdef OC_LOGD
#define OCLOGD(fmt, ...)            \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[SLogManager sharedInstance] logD:[NSString stringWithFormat:fmt,##__VA_ARGS__]]

#define OCLOGE(fmt, ...)    \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[SLogManager sharedInstance] logE:[NSString stringWithFormat:fmt,##__VA_ARGS__]]

#define OCLOGI(fmt, ...)    \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[SLogManager sharedInstance] logI:[NSString stringWithFormat:fmt,##__VA_ARGS__]]
//#else
//#define OCLOGD(fmt, ...){}
//#endif

//NSString *msg=[[NSString alloc]initWithFormat:fmt arguments:##args];
@protocol LogDelegate<NSObject>
-(void)onLog:(NSString*) msg;
-(void)onLogD:(NSString*) msg;
-(void)onLogI:(NSString*) msg;
-(void)onLogE:(NSString*) msg;
@end

@interface SLogManager : NSObject
@property(weak,nonatomic)id<LogDelegate> logDelegate;
@property(assign,nonatomic)bool isLocalCache;
@property(assign,nonatomic)LogType logType;
//@property(assign,nonatomic)bool isXcodePrint;

+(void)startWork;
+(void)startWorkOnLogType:(LogType)type;
+(void)startWorkOnLogType:(LogType)type ifCache:(bool)localCache;
+(instancetype)sharedInstance;
-(void)log:(NSString*)msg;
-(void)logD:(NSString*)msg;
-(void)logI:(NSString*)msg;
-(void)logE:(NSString*)msg;
-(void)logCrash:(NSException *)exception;
@end
