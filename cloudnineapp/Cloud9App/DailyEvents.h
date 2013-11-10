//
//  DailyEvents.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 09/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllEvents, EventDetail;

@interface DailyEvents : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * venueLogo;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) AllEvents *allEvents;
@property (nonatomic, retain) EventDetail *eventDetail;

@end
