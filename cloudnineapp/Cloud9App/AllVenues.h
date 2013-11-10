//
//  AllVenues.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 10/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AllVenues : NSManagedObject

@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * venueAddress;
@property (nonatomic, retain) NSString * eventCountDetail;
@property (nonatomic, retain) NSString * venueLogo;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSSet *eventsInVenue;
@end

@interface AllVenues (CoreDataGeneratedAccessors)

- (void)addEventsInVenueObject:(NSManagedObject *)value;
- (void)removeEventsInVenueObject:(NSManagedObject *)value;
- (void)addEventsInVenue:(NSSet *)values;
- (void)removeEventsInVenue:(NSSet *)values;

@end
