//
//  eventController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "eventController.h"

#import <QuartzCore/QuartzCore.h>
#import "MyJson.h"
#import "dailyEventsController.h"
#import "NSUtilities.h"
#import "FirstJsonLoader.h"
#import "BadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"


#define kjsonURL @"datesAndEvents.php"
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events"



@interface eventController ()

@end

@implementation eventController {
    
    NSMutableArray *jsonResults;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self launchLoadData];
    [self decorateView];
}

#pragma mark - launchLoadData and loadData are for a new thread
-(void)launchLoadData {
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) loadData {
    [app AddloadingView];
    [self processJson];
    [self.tableView reloadData];
    [app RemoveLoadingView];
}

// the process also has spinner or loader
- (void)processJson {
    MyJson * json = [[MyJson alloc] init];
    jsonResults = [json toArray:kjsonURL];
}

- (void)decorateView {
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:kTableBG] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title  = kTitle;
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jsonResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"eventCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    NSMutableString    *date = [eventCountDict objectForKey:@"date"];
    NSString    *count = [eventCountDict objectForKey:@"quantity"];
    NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Events",count];

    cell.titleLabel.text = [NSUtilities getFormatedDate:date];
    cell.descriptionLabel.text = countDetail;
    cell.moreLabel.text = countDetail;
    [cell addSubview: [NSUtilities getResizedImageViewForCell:[UIImage imageNamed:@"cell-logo.png"]]];
    
    //computing and displaying new events as badge
    int newEventCount = [BadgeManager countNewEventsOfDate:date];
    if (newEventCount > 0) {
        if(app.setBadge) {
            UIView *badgeView = [NSUtilities getBadgeLikeView:[NSString stringWithFormat:@"%i",newEventCount]:
                                 app.setBadge];
            badgeView.tag = 111;
            [cell addSubview:badgeView];
        }
        else {
            UIView *badge = [cell viewWithTag:111];
            [badge removeFromSuperview];
        }
    }
    return cell;
}


- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
   cell.backgroundView = bgView;

  UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
  cell.selectedBackgroundView = selBGView;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    NSString    *date = [eventCountDict objectForKey:@"date"];
    NSString    *count = [eventCountDict objectForKey:@"quantity"];
    NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Events",count];
    NSMutableString    *formattedDate = [NSUtilities getFormatedDate:date];
    
    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc]init];
    [eventDict setObject:date forKey:@"date"];
    [eventDict setObject:formattedDate forKey:@"formattedDate"];
    [eventDict setObject:countDetail forKey:@"countDetail"];
    
    
    dailyEventsController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"dailyEvents"];
    nextController.eventDict = eventDict;
    
    [self.navigationController pushViewController:nextController  animated: NO]; 
}





@end
