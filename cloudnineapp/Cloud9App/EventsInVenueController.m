//
//  EventsInVenueController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "EventsInVenueController.h"

#import <QuartzCore/QuartzCore.h>
#import "KSJson.h"
#import "EventDetailsController.h"
#import "KSUtilities.h"
#import "EventsInVenue.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "KSSettings.h"
#import "EventsInVenue.h"
#import "EventDetail.h"

#define kUrlGenres @"eventsOfAVenue.php?venue_id="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events in a Venue"
#define kBadgeTag 1111

@interface EventsInVenueController ()

@end

@implementation EventsInVenueController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [app AddloadingView];
    [self launchLoadData];
    [self decorateView];
    [self addRefreshing];
}
#pragma mark - launchLoadData and loadData are for a new thread
-(void)launchLoadData {
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}


- (void) loadData {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil    waitUntilDone:NO];
    [app RemoveLoadingView];
}


- (void)decorateView{
    
    [self setBackButton];
    self.navigationController.topViewController.title  = kTitle;
    
    //tableview background image
    UIGraphicsBeginImageContext(self.tableView.frame.size);
    [[UIImage imageNamed:kTableBG] drawInRect:self.tableView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:image];
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
    self.navigationController.navigationBar.topItem.title  = kTitle;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - table related
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_eventInVenueArray count];
}


// The main method to display data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"venueCell2";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    EventsInVenue *eventsInVenue = [_eventInVenueArray objectAtIndex:indexPath.row];

    cell.titleLabel.text = eventsInVenue.eventName;
    NSDictionary *dateDict = [KSUtilities getDateDict:eventsInVenue.date];
   [cell addSubview: [KSUtilities getCalendar:[dateDict objectForKey:@"shortMonth"] forDay:[dateDict objectForKey:@"dateDay"]]];
    
    //displaying new events as badge
    NSString    *eventId = eventsInVenue.eventId;
    NSMutableString *eventIdDate = [NSMutableString stringWithFormat:@"%@:%@",eventId, [NSMutableString stringWithString:eventsInVenue.date]];
    if ([KSBadgeManager isNewEvent:eventIdDate]) {
        if(app.setBadge) {
            UIView *badgeView = [KSUtilities getBadgeLikeView:[NSString stringWithFormat:@"new"] showHide:app.setBadge];
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

// header for the table view controller
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return [KSUtilities getHeaderView:[KSUtilities getImage:_venueLogo] forTitle:_venueName forDetail:_venueAddress];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}


#pragma mark - Back button;
-(void) setBackButton {
    UIButton *btn = [KSUtilities getBackButton];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventsInVenue *eventsInVenue = [_eventInVenueArray objectAtIndex:indexPath.row];
    EventDetailsController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    nextViewController.eventDetail = eventsInVenue.eventDetails;
    NSLog(@"eventInVenueController/didSelect...: eventName=%@", eventsInVenue.eventDetails.eventName);

    [self.navigationController pushViewController:nextViewController animated: NO];

}
@end
