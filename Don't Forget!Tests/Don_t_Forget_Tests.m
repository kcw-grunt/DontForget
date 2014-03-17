//
//  Don_t_Forget_Tests.m
//  Don't Forget!Tests
//
//  Created by Grunt - Kerry on 3/13/14.
//  Copyright (c) 2014 Grunt Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Task.h"

@interface Don_t_Forget_Tests : XCTestCase

@end

@implementation Don_t_Forget_Tests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

-(void)testForceTrue{
    XCTAssertTrue(2+2==4);
}
-(void)testForceFalse{
    XCTAssertFalse(200+3==4);
}

-(void)testTaskProperties{

    Task *testTask;
    
    ///Copied df format from imp from app
    NSDateFormatter *testDf = [[NSDateFormatter alloc] init];
    [testDf  setDateFormat:@"MMM d, YYYY"];
    [testDf setLocale:[NSLocale currentLocale]];
    [testDf setTimeZone:[NSTimeZone systemTimeZone]];

    
    ///Corner case task
    testTask.name = @"myTaskawrgv";////Random string for task name
    testTask.timeStamp = [NSDate date];
    testTask.detailedInfo = @"dfwwfwfwefcatwc3t3dergewlwcmiyu;gdfgegeegrrrr rgrrgrgrgrg";
    testTask.deadline = [NSDate dateWithTimeIntervalSince1970:-16000000];
    testTask.taskOrder = [NSNumber numberWithInt:895599555];///Very large index
    
    XCTAssertTrue(testTask.name.length < 100);
    XCTAssertTrue(testTask.detailedInfo.length < 240);
    XCTAssertTrue(testTask.taskOrder >= 0);
}





@end
