//
//  SLogTests.m
//  SLogTests
//
//  Created by SSS on 2019/6/17.
//  Copyright © 2019 SSS. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "SLog.h"
//#define OC_LOG
@interface SLogTests : XCTestCase

@end

@implementation SLogTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //OCLOG(@"123");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
//        [SLogManager startWorkOnLogMode:LogModeDebug ifCache:YES];//本地缓存所有日志
//        [[SLogManager sharedInstance]setIsErrorInfoCacheAlone:YES];//开启错误日志单独存储
    }];
}

@end
