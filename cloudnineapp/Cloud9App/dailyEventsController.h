//
//  dailyEventsController.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 23/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllEvents;

@interface dailyEventsController : UITableViewController

@property (retain, nonatomic) NSMutableDictionary *eventDict;
@property (retain, nonatomic) AllEvents *allEvents;


@end
