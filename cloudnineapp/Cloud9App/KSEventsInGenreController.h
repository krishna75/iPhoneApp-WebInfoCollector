//
//  KSEventsInGenreController.h
//  Cloud9App
//
//  Created by nerd on 19/04/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSEventsInGenreController : UITableViewController

@property (nonatomic,retain) NSArray *eventsInGenreArray;

@property (nonatomic,retain) NSString *genreName;
@property (nonatomic,retain) NSString *genreDescription;
@property (nonatomic,retain) NSString *genrePhoto;

@end
