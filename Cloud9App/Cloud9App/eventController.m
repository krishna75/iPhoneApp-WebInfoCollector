//
//  eventController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "eventController.h"

#import <QuartzCore/QuartzCore.h>
#import "KSJson.h"
#import "dailyEventsController.h"
#import "KSUtilities.h"
#import "FirstJsonLoader.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "KSSettings.h"

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

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self launchLoadData];
    [self decorateView];
    [self addRefreshing];
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
    KSJson * json = [[KSJson alloc] init];
    jsonResults = [json toArray:kjsonURL];
}

- (void)decorateView {
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:kTableBG] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void) addRefreshing {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)refresh {
    [self launchLoadData];
    [self.refreshControl endRefreshing];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//   the line below sets the font and size of the whole application. this has to be in the event controller since this is the first view controller.
//    [[UILabel appearance] setFont:[UIFont fontWithName:[KSUtilities getDefaultFont] size:12.0]];

    UIImage *backgroundImage = [UIImage imageNamed:@"bg_top_nav.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
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
    if (count == nil) {count = @"No" ; }
    NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Event(s)",count];

    cell.titleLabel.text = countDetail;

    NSArray *dateArray = [KSUtilities getDateComponents:date];
    [cell addSubview: [KSUtilities getCalendar:[dateArray objectAtIndex:2] forDay:[dateArray objectAtIndex:1]]];
    
    //computing and displaying new events as badge
    int newEventCount = [KSBadgeManager countNewEventsOfDate:date];
    if (newEventCount > 0) {
        if(app.setBadge) {
            UIView *badgeView = [KSUtilities getBadgeLikeView:[NSString stringWithFormat:@"%i", newEventCount] showHide:app.setBadge];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KSSettings tableCellHeight];
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
    if (count == nil) {count = @"No" ; }
    NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Event(s)",count];
    NSMutableString    *formattedDate = [KSUtilities getFormatedDate:date];
    
    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc]init];
    [eventDict setObject:date forKey:@"date"];
    [eventDict setObject:formattedDate forKey:@"formattedDate"];
    [eventDict setObject:countDetail forKey:@"countDetail"];
    
    
    dailyEventsController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"dailyEvents"];
    nextController.eventDict = eventDict;
    
    [self.navigationController pushViewController:nextController  animated: NO]; 
}





@end
