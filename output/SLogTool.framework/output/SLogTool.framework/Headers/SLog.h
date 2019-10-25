//
//  SLog.h
//  SLog
//
//  Created by SSS on 2019/6/17.
//  Copyright © 2019 SSS. All rights reserved.
//



// In this header, you should import all the public headers of your framework using statements like #import <SLog/PublicHeader.h>


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
// iOS Simulator
// iOS device
#import <UIKit/UIKit.h>
//! Project version number for SLog.
FOUNDATION_EXPORT double SLogVersionNumber;

//! Project version string for SLog.
FOUNDATION_EXPORT const unsigned char SLogVersionString[];

#elif TARGET_OS_MAC

// Other kinds of Mac OS
#import <Cocoa/Cocoa.h>
//! Project version number for SLog_Mac.
FOUNDATION_EXPORT double SLog_MacVersionNumber;

//! Project version string for SLog_Mac.
FOUNDATION_EXPORT const unsigned char SLog_MacVersionString[];
#else
#   error "Unknown Apple platform"
#endif
#import "SLogManager.h"
