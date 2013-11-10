//
//  EventsInVenue.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 10/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllVenues, EventDetail;

@interface EventsInVenue : NSManagedObject

@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) AllVenues *allVenues;
@property (nonatomic, retain) EventDetail *eventDetails;

@end
