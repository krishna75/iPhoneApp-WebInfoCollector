//
//  EventsInVenueController.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllVenues.h"

@class EventsInVenue;

@interface EventsInVenueController : UITableViewController

@property (retain, nonatomic) NSString* venueLogo;
@property (retain, nonatomic) NSString* venueName;
@property (retain, nonatomic) NSString* venueAddress;

@property (retain, nonatomic) NSArray* eventInVenueArray;
- (void) addToCalendar:(id) sender;

@end
