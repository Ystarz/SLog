//
//  SLogManager.h
//  im_core_ios
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDataTools/SDataTools.h>
//#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
//// iOS Simulator
//// iOS device
//
//#elif TARGET_OS_MAC
//// Other kinds of Mac OS
//#import <SDataToolsLib/SDataToolsLib_Mac.h>
//#else
//#   error "Unknown Apple platform"
//#endif


typedef enum{
    LogTypeNormal=1<<0,
    LogTypeDebug=1<<1,
    LogTypeInfo=1<<2,
    LogTypeError=1<<3,
} LogType;

typedef enum{
    LogModeDebug=1<<0,
    LogModeRealease=1<<1,
    LogModeNone=1<<2,
} LogMode;


#define OCLOG(fmt, ...)    \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[SLogManager sharedInstance] log:[NSString stringWithFormat:fmt,##__VA_ARGS__]]


#define OCLOGD(fmt, ...)            \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[SLogManager sharedInstance] logD:[NSString stringWithFormat:fmt,##__VA_ARGS__]]


#define OCLOGE(fmt, ...)    \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[SLogManager sharedInstance] logE:[NSString stringWithFormat:fmt,##__VA_ARGS__]]


#define OCLOGI(fmt, ...)    \
(NSLog)((fmt), ##__VA_ARGS__);           \
[[SLogManager sharedInstance] logI:[NSString stringWithFormat:fmt,##__VA_ARGS__]]


@protocol SLogDelegate<NSObject>
-(void)onLog:(NSString*) msg;
-(void)onLogD:(NSString*) msg;
-(void)onLogI:(NSString*) msg;
-(void)onLogE:(NSString*) msg;
@end

@interface SLogManager : NSObject
@property(weak,nonatomic)id<SLogDelegate> logDelegate;
@property(assign,nonatomic)bool isLocalCache;
@property(assign,nonatomic)LogMode logMode;
//@property(assign,nonatomic)bool isXcodePrint;

+(void)startWork;
+(void)startWorkOnLogMode:(LogMode)type;
+(void)startWorkOnLogMode:(LogMode)type ifCache:(bool)localCache;
+(instancetype)sharedInstance;
-(void)log:(NSString*)msg;
-(void)logD:(NSString*)msg;
-(void)logI:(NSString*)msg;
-(void)logE:(NSString*)msg;
-(void)logCrash:(NSException *)exception;
@end
