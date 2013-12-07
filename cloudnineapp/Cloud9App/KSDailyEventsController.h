//
//  KSDailyEventsController.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 23/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSAllEvents;

@interface KSDailyEventsController : UITableViewController
@property (retain, nonatomic) NSArray *dailyEventsArray;
@property (retain, nonatomic) NSString *date;


@end
