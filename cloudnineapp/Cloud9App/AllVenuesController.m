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

// the process also has spinner or loader
- (void)processJson {
    KSJson * json = [[KSJson alloc] init];
    if ([json isConnectionAvailable]){
        NSArray * jsonResults = [json toArray:kAllVenuesUrl];
        [self createCoreData: jsonResults];
    } else {
        coreDataResults = [self loadCoreData];
    }
}

- (NSArray *) loadCoreData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllVenues" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

- (void) createCoreData: (NSArray *) jsonResults {

    NSArray *lastSaved = [self loadCoreData];
    NSMutableArray *results = [[NSMutableArray alloc] init] ;

    //get the context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    for (NSDictionary *jsonDict in jsonResults) {

        //all venues
        AllVenues *allVenues = [NSEntityDescription insertNewObjectForEntityForName:@"AllVenues" inManagedObjectContext:context];
        allVenues.date = [jsonDict objectForKey:@"date"];
        allVenues.venueId = [jsonDict objectForKey:@"venue_id"];
        allVenues.venueName = [jsonDict objectForKey:@"name"];
        allVenues.venueAddress = [jsonDict  objectForKey:@"address"];
        allVenues.venueLogo = [jsonDict objectForKey:@"logo"];
        NSMutableString *quantity = [jsonDict objectForKey:@"quantity"];
        allVenues.eventCountDetail = [NSMutableString stringWithFormat:@"%@ Event(s)",quantity];

        // events in a venue
        NSMutableArray *eventsInVenueArray = [[NSMutableArray alloc] init];
        KSJson * json = [[KSJson alloc] init];
        NSString *jsonURL  = [NSString stringWithFormat:@"%@%@", kEventsOfVenueUrl, allVenues.venueId];
        NSLog(@"AllVenuesController/createCoreData: jsonUrl = %@", jsonURL) ;

        for (NSDictionary *eventsInVenueDict in [json toArray:jsonURL]) {
            EventsInVenue *eventsInVenue = [NSEntityDescription insertNewObjectForEntityForName:@"EventsInVenue" inManagedObjectContext:context];
            eventsInVenue.eventId = [eventsInVenueDict objectForKey:@"event_id"];
            eventsInVenue.date = [eventsInVenueDict objectForKey:@"date"];
            eventsInVenue.eventName = [eventsInVenueDict objectForKey:@"event_title"];

            // relations
            eventsInVenue.allVenues = allVenues;
            [eventsInVenueArray addObject:eventsInVenue];

            // event detail
            NSString * eventDetailUrl = [NSString stringWithFormat:@"%@%@", kEventDetailUrl,eventsInVenue.eventId];
            NSDictionary *eventDetailDict = [[json toArray:eventDetailUrl] objectAtIndex:0];

            EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:context];
            eventDetail.date = [eventDetailDict objectForKey:@"date"];
            eventDetail.eventDescription = [eventDetailDict objectForKey:@"description"];
            eventDetail.eventId= [eventDetailDict objectForKey:@"id"];
            eventDetail.eventName = [eventDetailDict objectForKey:@"title"];
            eventDetail.photo = [eventDetailDict objectForKey:@"photo"];

            eventDetail.venueId = [eventDetailDict objectForKey:@"venue_id"];
            eventDetail.venueName = [eventDetailDict objectForKey:@"venue"];

            eventDetail.voucherDescription= [eventDetailDict objectForKey:@"voucher_description"];
            eventDetail.voucherPhoto= [eventDetailDict objectForKey:@"voucher_photo"];

            NSLog(@"AllVenuesController/createCoreData: eventName=%@",eventDetail.eventName);

            // relations
            eventDetail.eventsInVenue = eventsInVenue;
            eventsInVenue.eventDetails = eventDetail;
        }
        NSLog(@"AllVenuesController/createCoreData: eventsInVenueArray.size = %d", [eventsInVenueArray count]) ;

        // relation
        allVenues.eventsInVenue = [NSSet setWithArray:eventsInVenueArray] ;

        //checking if the  data already exists
        BOOL saveOk = YES;
        for (AllVenues * lastVenue in lastSaved ) {
            if ([lastVenue.eventId isEqualToString:allVenues.eventId]){
                saveOk = NO;
            }
        }

        // saving data
        NSError *error = nil;
        if (saveOk) {
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        [results addObject:allVenues];
    }
    coreDataResults = results;
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
    return [coreDataResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"venueCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    
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
    nextController.eventInVenueArray= [allVenues.eventsInVenue allObjects];
    nextController.venueLogo= allVenues.venueLogo;
    nextController.venueName= allVenues.venueName;
    nextController.venueAddress= allVenues.venueAddress;

    [self.navigationController pushViewController:nextController  animated: NO];
}

@end
