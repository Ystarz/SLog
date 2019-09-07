//
//  SLog_MacTests.m
//  SLog_MacTests
//
//  Created by SSS on 2019/6/26.
//  Copyright © 2019 SSS. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLog.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
@interface SLog_MacTests : XCTestCase

@end

@implementation SLog_MacTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [SLogManager startWorkOnLogMode:LogModeDebug ifCache:YES];//本地缓存所有日志
        [[SLogManager sharedInstance]setIsErrorInfoCacheAlone:YES];//开启错误日志单独存储
    }];
}

@end
