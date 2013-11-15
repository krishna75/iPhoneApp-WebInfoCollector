//
//  KSBadgeManager.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 27/03/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSBadgeManager.h"
#import "KSJson.h"
#import "KSUtilities.h"

static NSMutableDictionary *eventViewedDict = nil;

@implementation KSBadgeManager
    
+ (void) initialize {
    eventViewedDict = [KSBadgeManager readDict];
    NSLog(@"KSBadgeManager initialize: total dict size read from file , %i", eventViewedDict.allKeys.count );
    if (!eventViewedDict){
        eventViewedDict = [[NSMutableDictionary alloc]init];
    }
    [KSBadgeManager updateEvents];
}


+ (void)saveDict {

}

+ (void) updateEvents {
    [KSBadgeManager removePastEvents:eventViewedDict];
    KSJson *json = [[KSJson alloc] init];
    NSArray *jsonResults = [json toArray:@"eventsForBadgeManager.php"];
    
    NSLog(@"KSBadgeManager updateEvents: size of the json results: %i", [jsonResults count]);
       for (int i= 0; i< jsonResults.count; i++) {
            NSMutableDictionary *eventCountDict = [jsonResults objectAtIndex:i];
            NSMutableString    *eventId = [eventCountDict objectForKey:@"id"];
            NSMutableString    *date = [eventCountDict objectForKey:@"date"];
            NSMutableString  *eventKey = [NSString stringWithFormat:@"%@:%@",eventId,date];
           if (![eventViewedDict.allKeys containsObject:eventKey]) {
               [eventViewedDict setObject:@"UNVIEWED" forKey:eventKey];
           }
    
       }
    
    NSLog(@"KSBadgeManager updateEvents: total dict size , %i", eventViewedDict.allKeys.count );
    [KSBadgeManager computeNewEvents];
}


+ (void) computeNewEvents {
    int newEventCount = 0;
    for (int i = 0; i< [eventViewedDict.allValues  count]; i++) {
        if ([eventViewedDict.allValues[i] isEqual: @"UNVIEWED"]){
            newEventCount ++;
        }
    }
  [UIApplication sharedApplication].applicationIconBadgeNumber = newEventCount;
    [KSBadgeManager saveDict:eventViewedDict];
}




+ (void) addViewedEvent: (NSMutableString *) eventId onDate: (NSMutableString *) date {
    NSMutableString *eventKey = [NSString stringWithFormat:@"%@:%@",eventId,date];
    NSLog(@"KSBadgeManager addViewedEvent: %@", eventKey);
    for (int i = 0; i< [eventViewedDict count]; i++) {
        if ([eventViewedDict.allKeys[i] isEqual: eventKey]){
            [eventViewedDict setObject:@"VIEWED" forKey:eventKey];
        }
    }
    
    [KSBadgeManager computeNewEvents];
}


#pragma mark - Event counting
+ (int) countNewEvents: (NSMutableArray *) eventIds {
    int newEventCount = 0;
    for (int i = 0; i< [eventIds  count]; i++) {
        NSMutableString *eventId = [eventIds objectAtIndex:i];
        if ([KSBadgeManager isNewEvent:eventId]){
            newEventCount++;
        }
    }
    return newEventCount;
}

+ (Boolean) isNewEvent: (NSMutableString *) eventId {
    NSMutableString *value = [eventViewedDict objectForKey:eventId];
    if ([value isEqual: @"VIEWED"]){
        return FALSE;
    } else {
        return TRUE;
    }
}


+ (int) countNewEventsOfDate:(NSMutableString *) date {
    return [KSBadgeManager countNewEvents:[KSBadgeManager listEventsOfDate:date]];
}


+ (NSMutableArray *) listEventsOfDate: (NSMutableString *) date {
    NSMutableArray *eventIds = [[NSMutableArray alloc]init];
    for (int i = 0; i< [eventViewedDict.allKeys  count]; i++) {
        NSMutableString *eventKey = [eventViewedDict.allKeys objectAtIndex:i];
        NSMutableString *dictDate =  [[eventKey  componentsSeparatedByString:@":"] objectAtIndex:1];
        if ([dictDate isEqual:date]){
            [eventIds addObject:eventKey];        }
    }
    return eventIds;
}

#pragma mark - removing past dates
+ (NSMutableDictionary *) removePastEvents: (NSMutableDictionary *) eventDictionary {
    for (int i = 0; i< [eventDictionary.allKeys  count]; i++) {
        NSMutableString *eventKey = [eventDictionary.allKeys objectAtIndex:i];
        NSMutableString *date =  [[eventKey  componentsSeparatedByString:@":"] objectAtIndex:1];
        if ([KSBadgeManager isPastDate:date]){
            [eventDictionary removeObjectForKey:eventKey];
        }
    }
    return eventDictionary;
}


+ (Boolean) isPastDate: (NSString *) dateString {
    NSString *timeDateString = [NSString stringWithFormat:@"%@ 00:00:00",dateString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeDateString];
    
    NSString *timeTodayString = [NSString stringWithFormat:@"%@ 00:00:00",[KSUtilities getToday]];
    NSDate *today = [formatter dateFromString:timeTodayString];
    
    NSComparisonResult result = [date compare:today];
    Boolean isPast = FALSE;
    switch (result) {
        case NSOrderedAscending: isPast = TRUE; break;
        case NSOrderedDescending: isPast = FALSE; break;
        case NSOrderedSame:  isPast = FALSE; break;
        default: isPast = FALSE; break;
    }
    
    return isPast;
}


#pragma mark - File operations

+ (void) saveDict:(NSDictionary *)viewedDict {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:viewedDict forKey:@"viewedDict"];
    [defaults synchronize];
}

+ (NSMutableDictionary *) readDict {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *viewedDict = [defaults objectForKey:@"viewedDict"];
    return viewedDict;
}


@end
