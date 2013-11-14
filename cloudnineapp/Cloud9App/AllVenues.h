//
//  AllVenues.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 14/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventsInVenue;

@interface AllVenues : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * eventCountDetail;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * venueAddress;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * venueLogo;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSSet *eventsInVenue;
@end

@interface AllVenues (CoreDataGeneratedAccessors)

- (void)addEventsInVenueObject:(EventsInVenue *)value;
- (void)removeEventsInVenueObject:(EventsInVenue *)value;
- (void)addEventsInVenue:(NSSet *)values;
- (void)removeEventsInVenue:(NSSet *)values;

@end
