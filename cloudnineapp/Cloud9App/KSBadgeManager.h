//
//  KSBadgeManager.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 27/03/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSBadgeManager : NSObject


+ (void) saveDict;
+ (void) updateEvents;
+ (void) computeNewEvents;
+ (int) countNewEvents: (NSMutableArray *) eventIds;
+ (Boolean) isNewEvent: (NSMutableString *) eventId;
+ (int) countNewEventsOfDate:(NSMutableString *) date;
+ (NSMutableArray *) listEventsOfDate: (NSMutableString *) date;
+ (void) addViewedEvent: (NSMutableString *) eventId onDate: (NSMutableString *) date;
+ (Boolean) isPastDate: (NSString *) dateString;
+ (NSMutableDictionary *) removePastEvents: (NSMutableDictionary *) eventDictionary;

@end
