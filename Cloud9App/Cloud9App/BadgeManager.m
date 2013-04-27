//
//  BadgeManager.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 27/03/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "BadgeManager.h"
#import "MyJson.h"
#import "NSUtilities.h"

static NSMutableDictionary *eventViewedDict = nil;

@implementation BadgeManager  
    
+ (void) initialize {
    eventViewedDict = [BadgeManager readDict];
    NSLog(@" total dict sizeread from file , %i", eventViewedDict.allKeys.count );
    if (!eventViewedDict){
        eventViewedDict = [[NSMutableDictionary alloc]init];
    }
    [BadgeManager updateEvents];
}



+ (void) updateEvents {
    [BadgeManager removePastEvents:eventViewedDict];
    MyJson *json = [[MyJson alloc] init];
    NSArray *jsonResults = [json toArray:@"http://www.chitwan-abroad.org/cloud9/eventsForBadgeManager.php"];
    
    NSLog(@"size of the json results: %i", [jsonResults count]);
       for (int i= 0; i< jsonResults.count; i++) {
            NSMutableDictionary *eventCountDict = [jsonResults objectAtIndex:i];
            NSMutableString    *eventId = [eventCountDict objectForKey:@"id"];
            NSMutableString    *date = [eventCountDict objectForKey:@"date"];
            NSMutableString  *eventKey = [NSString stringWithFormat:@"%@:%@",eventId,date];
           if (![eventViewedDict.allKeys containsObject:eventKey]) {
               [eventViewedDict setObject:@"UNVIEWED" forKey:eventKey];
           }
    
       }
    
    NSLog(@" total dict size , %i", eventViewedDict.allKeys.count );
    [BadgeManager computeNewEvents];
}


+ (void) computeNewEvents {
    int newEventCount = 0;
    for (int i = 0; i< [eventViewedDict.allValues  count]; i++) {
        if ([eventViewedDict.allValues[i] isEqual: @"UNVIEWED"]){
            newEventCount ++;
        }
    }
  [UIApplication sharedApplication].applicationIconBadgeNumber = newEventCount;
    [BadgeManager saveDict: eventViewedDict];
}




+ (void) addViewedEvent: (NSMutableString *) eventId onDate: (NSMutableString *) date {
    NSMutableString *eventKey = [NSString stringWithFormat:@"%@:%@",eventId,date];
    NSLog(@"%@", eventKey);
    for (int i = 0; i< [eventViewedDict count]; i++) {
        if ([eventViewedDict.allKeys[i] isEqual: eventKey]){
            [eventViewedDict setObject:@"VIEWED" forKey:eventKey];
        }
    }
    
    [BadgeManager computeNewEvents];
}


#pragma mark - Event counting
+ (int) countNewEvents: (NSMutableArray *) eventIds {
    int newEventCount = 0;
    for (int i = 0; i< [eventIds  count]; i++) {
        NSMutableString *eventId = [eventIds objectAtIndex:i];
        if ([BadgeManager isNewEvent:eventId]){
            newEventCount++;
        }
    }
    return newEventCount;
}

+ (Boolean) isNewEvent: (NSMutableString *) eventId {
    NSMutableString *value = [eventViewedDict objectForKey:eventId];
    NSLog(@"value = %@",value);
    if ([value isEqual: @"VIEWED"]){
        return FALSE;
    } else {
        return TRUE;
    }
}


+ (int) countNewEventsOfDate:(NSMutableString *) date {
    return [BadgeManager countNewEvents:[BadgeManager listEventsOfDate:date]];
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
        if ([BadgeManager isPastDate:date]){
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
    
    NSString *timeTodayString = [NSString stringWithFormat:@"%@ 00:00:00",[NSUtilities getToday]];
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
