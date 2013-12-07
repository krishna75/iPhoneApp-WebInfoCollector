//
//  KSAllVenues.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 14/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSEventsInVenue;

@interface KSAllVenues : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * eventCountDetail;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * venueAddress;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * venueLogo;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSSet *eventsInVenue;
@end

@interface KSAllVenues (CoreDataGeneratedAccessors)

- (void)addEventsInVenueObject:(KSEventsInVenue *)value;
- (void)removeEventsInVenueObject:(KSEventsInVenue *)value;
- (void)addEventsInVenue:(NSSet *)values;
- (void)removeEventsInVenue:(NSSet *)values;

@end
