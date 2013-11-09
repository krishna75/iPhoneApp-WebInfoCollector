//
//  MyAppLogicTests.m
//  MyAppLogicTests
//
//  Created by Krishna Sapkota on 01/04/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "MyAppLogicTests.h"
#import "KSBadgeManager.h"
#import "KSUtilities.h"

@implementation MyAppLogicTests

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

- (void) testInitialisation {
    [KSBadgeManager initialize];
}



- (void) testPassedDate {
    STAssertTrue([KSBadgeManager isPastDate:@"2013-03-25"], @"the date must be passed date");
    STAssertFalse([KSBadgeManager isPastDate:@"2013-04-30"], @"the date must be future date");
}

- (void) testRemovingPastEvents {
    NSMutableDictionary * eventDict = [[NSMutableDictionary alloc] init];
    [eventDict setObject:@"VIEWED" forKey:@"event_1:2013-03-25"];
    [eventDict setObject:@"UNVIEWED" forKeyedSubscript:@"event_1:2013-04-25"];
    
    STAssertTrue([eventDict count]== 2, nil);
    [KSBadgeManager removePastEvents:eventDict];
    STAssertTrue([eventDict count]== 1, nil);
}

- (void) testIsNewEvent {
    
    NSMutableString *eventId = [NSMutableString stringWithFormat:@"11:2013-04-25"];
    STAssertTrue([KSBadgeManager isNewEvent:eventId], @"the event should be new (unviewed) event");
    
    [KSBadgeManager addViewedEvent:@"11" onDate:@"2013-04-25"];
    STAssertFalse([KSBadgeManager isNewEvent:eventId], @"the event should be old (viewed) event");
}

- (void) testCountNewEvents {
    NSMutableArray *eventIds = [[NSMutableArray alloc] init];
    [eventIds  addObject:@"1:2013-04-25"];
    [eventIds  addObject:@"3:2013-04-25"];
    [eventIds  addObject:@"5:2013-04-25"];
    [eventIds  addObject:@"7:2013-04-25"];
    [eventIds  addObject:@"9:2013-04-25"];
    [eventIds  addObject:@"11:2013-04-25"];
    
    int newEventCount = [KSBadgeManager countNewEvents:eventIds];
    STAssertEquals(6, newEventCount, @"must be 6 new events");
    
    [KSBadgeManager addViewedEvent:@"11" onDate:@"2013-04-25"];
    newEventCount = [KSBadgeManager countNewEvents:eventIds];
    STAssertEquals(5, newEventCount, @"must be 5 new events");
    
}

- (void) testCountNewEventsOfDate {
    int newEventCount = [KSBadgeManager countNewEventsOfDate:@"2013-04-28"];
    STAssertEquals(6, newEventCount, @"must be 6 new events");
}



@end
