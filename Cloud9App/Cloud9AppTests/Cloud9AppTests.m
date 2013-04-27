//
//  Cloud9AppTests.m
//  Cloud9AppTests
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "Cloud9AppTests.h"
#import "BadgeManager.h"

@implementation Cloud9AppTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testIsPastDate {
    STAssertTrue([BadgeManager isPastDate:@"2013-03-30"], @"the date must be passed date");
    //    [BadgeManager isPastDate:@"2013-04-03"];
    //    [BadgeManager isPastDate:@"2013-04-01"];
}



@end
