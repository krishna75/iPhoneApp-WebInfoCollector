//
//  venuesAndEventsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "venuesAndEventsController.h"
#import "KSJson.h"
#import "eventsInAVenueController.h"
#import "FirstJsonLoader.h"
#import "KSUtilities.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "KSSettings.h"

#define kjsonUrlEventsOfVenue @"vouchers.php"
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"


@interface venuesAndEventsController ()

@end

@implementation venuesAndEventsController {
    NSMutableArray *eventDictArray;
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

// the process also has spinner or loader
- (void)processJson {
    [FirstJsonLoader procesJson];
    eventDictArray = [FirstJsonLoader getVenues];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [eventDictArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"venueCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    
    NSDictionary *eventDict = [eventDictArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [eventDict objectForKey:@"name"];
    cell.moreLabel.text = [eventDict objectForKey:@"address"];
    cell.descriptionLabel.text = [eventDict objectForKey:@"countDetail"];
    [cell addSubview: [KSUtilities getImageViewOfUrl:[eventDict objectForKey:@"logo"]]];
    
    // displaying events as a badge
    NSMutableArray *eventIdList = [[NSMutableArray alloc] init];
    KSJson * json = [[KSJson alloc] init];
    NSString *jsonURL  = [NSString stringWithFormat:@"%@%@",kjsonUrlEventsOfVenue,[eventDict objectForKey:@"venue_id" ]];
    NSMutableArray *eventsForBadge = [json toArray:jsonURL];
    for (int i = 0; i < [eventsForBadge count]; i++) {
        NSDictionary *eventForBadgeDict = [eventsForBadge objectAtIndex:i];
        NSMutableString   *eventId= [eventForBadgeDict objectForKey:@"event_id"];
        NSMutableString *date = [eventForBadgeDict objectForKey:@"date"];
        [eventIdList addObject:[NSMutableString stringWithFormat:@"%@:%@",eventId,date]];   
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
    NSDictionary *eventCountDict = [eventDictArray objectAtIndex:indexPath.row];
    NSString *venueId = [eventCountDict objectForKey:@"venue_id"];
    NSString    *venueName = [eventCountDict objectForKey:@"name"];
    NSString    *venueAddress = [eventCountDict objectForKey:@"address"];
    UIImage *logo = [eventCountDict objectForKey:@"logo"];
    
    NSMutableDictionary *venueDict = [[NSMutableDictionary alloc] init];
    [venueDict setObject:venueId forKey:@"venue_id"];
    [venueDict setObject:venueName forKey:@"name"];
    [venueDict setObject:venueAddress forKey:@"address"];
    [venueDict setObject:logo forKey:@"logo"];
    
    
    eventsInAVenueController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsInAVenue"];
    nextController.venueDict = venueDict;
    
    [self.navigationController pushViewController:nextController  animated: NO];    
}

@end
