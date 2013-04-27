//
//  eventsInAVenueController.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventsInAVenueController : UITableViewController

@property (retain, nonatomic) NSMutableDictionary *venueDict;
- (void) addToCalendar:(id) sender;

@end
