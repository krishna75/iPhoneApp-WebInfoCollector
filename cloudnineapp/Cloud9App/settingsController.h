//
//  settingsController.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 21/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *settingsTable;
    NSDictionary *settingsDict;
}


@end
