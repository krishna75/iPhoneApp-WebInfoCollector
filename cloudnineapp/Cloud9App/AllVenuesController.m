//
//  AllVenuesController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "AllVenuesController.h"
#import "KSJson.h"
#import "EventsInVenueController.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "EventsInVenue.h"
#import "EventDetail.h"
#import "DailyEvents.h"
#import "KSCoreDataManager.h"

#define kAllVenuesUrl @"venuesAndEvents.php"
#define kEventsOfVenueUrl @"eventsOfAVenue.php?venue_id="
#define kEventDetailUrl @"eventDetail.php?event_id="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"


@interface AllVenuesController ()

@end

@implementation AllVenuesController {
    NSArray* coreDataResults;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [self processJson];
    [self.tableView reloadData];
    [app RemoveLoadingView];
}

- (void)processJson {
    [KSCoreDataManager createVenues];
    coreDataResults = [KSCoreDataManager getVenues];
}

- (void)decorateView{
    
    // table view background image
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
    self.navigationController.navigationBar.topItem.title  = @"Venues";
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ return [coreDataResults count];}

// populating the cells in the table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // get the cell

    static NSString *CellIdentifier = @"venueCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }

    // populate
    AllVenues*allVenues= [coreDataResults objectAtIndex:indexPath.row];
    cell.titleLabel.text = allVenues.venueName;
    cell.moreLabel.text = allVenues.venueAddress;
    cell.descriptionLabel.text = allVenues.eventCountDetail;
    [cell addSubview: [KSUtilities getImageViewOfUrl:allVenues.venueLogo]];
    
    // displaying events as a badge
    NSMutableArray *eventIdList = [[NSMutableArray alloc] init];
    for (EventsInVenue *eventsInVenue in allVenues.eventsInVenue) {
        [eventIdList addObject:[NSMutableString stringWithFormat:@"%@:%@",eventsInVenue.eventId,eventsInVenue.date]];
    }
    
    //badges
    int newEventCount = [KSBadgeManager countNewEvents:eventIdList];
    if (newEventCount > 0) {
        if(app.setBadge) {
            UIView *badgeView = [KSUtilities getBadgeLikeView:[NSString stringWithFormat:@"%i", newEventCount] showHide:app.setBadge];
            badgeView.tag = 111;
            [cell.contentView addSubview:badgeView];
        }
        else {
            UIView *badge = [cell.contentView viewWithTag:111];
            [badge removeFromSuperview];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    AllVenues* allVenues = [coreDataResults objectAtIndex:indexPath.row];
    EventsInVenueController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsInAVenue"];

    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    nextController.eventInVenueArray = [[allVenues.eventsInVenue allObjects] sortedArrayUsingDescriptors:sortDescriptors];

    nextController.venueLogo= allVenues.venueLogo;
    nextController.venueName= allVenues.venueName;
    nextController.venueAddress= allVenues.venueAddress;

    [self.navigationController pushViewController:nextController  animated: NO];
}

@end
