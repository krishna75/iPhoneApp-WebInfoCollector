//
//  KSDailyEvents.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 15/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSAllEvents, KSEventDetail;

@interface KSDailyEvents : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * weekDay;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * venueLogo;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) KSAllEvents *allEvents;
@property (nonatomic, retain) KSEventDetail *eventDetail;

@end
