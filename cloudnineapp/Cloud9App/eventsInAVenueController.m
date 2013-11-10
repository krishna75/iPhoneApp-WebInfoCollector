//
//  eventsInAVenueController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "eventsInAVenueController.h"

#import <QuartzCore/QuartzCore.h>
#import "KSJson.h"
#import "eventDetailsController.h"
#import "KSUtilities.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "KSSettings.h"
#import "EventsInVenue.h"

#define kjsonURL @"eventsOfAVenue.php?venue_id="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events in a Venue"
#define kBadgeTag 1111

@interface eventsInAVenueController ()

@end

@implementation eventsInAVenueController {
    NSArray *coreDataResults;

}
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
    [self processCoreData];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil    waitUntilDone:NO];
    [app RemoveLoadingView];
}

// the process also has spinner or loader
- (void)processCoreData {
    
    //loading... spinnner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // converting the coredata set to array
    coreDataResults = [_allVenues.eventsInVenue allObjects];
    NSLog(@"eventsInAVenue/processCoreData: total events in a venue = %d",[coreDataResults count]) ;

    [spinner stopAnimating];
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
    return [coreDataResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"venueCell2";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    EventsInVenue *eventsInVenue = [coreDataResults objectAtIndex:indexPath.row];

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

    UIImage *logoImage = [KSUtilities getImage:_allVenues.venueLogo] ;
    return [KSUtilities getHeaderView:logoImage forTitle:_allVenues.venueName forDetail:_allVenues.venueAddress];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *appsDict = [jsonResults objectAtIndex:indexPath.row];
//    NSString *eventId = [appsDict objectForKey:@"event_id"];
//
//    eventDetailsController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
//    nextViewController.eventId = eventId;
//
//    [self.navigationController pushViewController:nextViewController animated: NO];
//
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
@end
