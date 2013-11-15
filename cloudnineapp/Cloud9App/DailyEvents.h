//
//  DailyEvents.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 15/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllEvents, EventDetail;

@interface DailyEvents : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * weekDay;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * venueLogo;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) AllEvents *allEvents;
@property (nonatomic, retain) EventDetail *eventDetail;

@end
