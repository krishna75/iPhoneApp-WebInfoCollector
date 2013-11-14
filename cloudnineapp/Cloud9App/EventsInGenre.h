//
//  EventsInGenre.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 14/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventDetail;

@interface EventsInGenre : NSManagedObject

@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * weekDay;
@property (nonatomic, retain) NSManagedObject *allGenres;
@property (nonatomic, retain) EventDetail *eventDetails;

@end
