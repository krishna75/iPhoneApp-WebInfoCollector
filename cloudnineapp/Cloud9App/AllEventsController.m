//
//  AllEventsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "AllEventsController.h"

#import "KSJson.h"
#import "DailyEventsController.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "DailyEvents.h"
#import "EventDetail.h"
#import "KSCoreDataManager.h"


#define kUrlEvents @"datesAndEvents.php"
#define kUrlDailyEvents @"eventsOfADate.php?event_date="
#define kEventDetailUrl @"eventDetail.php?event_id="

#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events"



@interface AllEventsController ()

@end

@implementation AllEventsController {
    NSArray *coreDataResults;
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
    NSLog(@"AllEventsController/viewDidLoad: AllEvents size = %d",[coreDataResults count])  ;
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

- (void)processJson {
    [KSCoreDataManager createEvents];
     coreDataResults = [KSCoreDataManager getEvents];
}

//- (NSArray *) loadCoreData {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllEvents" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    return [context executeFetchRequest:fetchRequest error:&error];
//}
//
//- (void) createCoreData: (NSArray *) jsonResults {
//    NSArray *lastSaved = [self loadCoreData];
//    NSMutableArray *results = [[NSMutableArray alloc] init] ;
//
//    // creating the context for the core data
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//
//    for (NSDictionary * eventCountDict in jsonResults) {
//
//        // all events
//        AllEvents *allEvents = [NSEntityDescription insertNewObjectForEntityForName:@"AllEvents" inManagedObjectContext:context];
//        allEvents.count = [eventCountDict objectForKey:@"quantity"] ;
//        allEvents.date = [eventCountDict objectForKey:@"date"] ;
//        allEvents.weekDay = [eventCountDict objectForKey:@"day"] ;
//
//        // daily events
//        NSMutableArray *dailyEventsArray = [[NSMutableArray alloc] init];
//        KSJson * json = [[KSJson alloc] init];
//        NSString *urlDailyEvents  = [NSString stringWithFormat:@"%@%@", kUrlDailyEvents, allEvents.date];
//        NSLog(@"AllEventsController/createCoreData: kUrlDailyEvents = %@", urlDailyEvents) ;
//
//        for (NSDictionary *dailyEventsDict in [json toArray:urlDailyEvents]) {
//            DailyEvents *dailyEvents = [NSEntityDescription insertNewObjectForEntityForName:@"DailyEvents" inManagedObjectContext:context];
//            dailyEvents.date = [dailyEventsDict objectForKey:@"date"];
//            dailyEvents.weekDay = [dailyEventsDict objectForKey:@"day"];
//
//            dailyEvents.eventId = [dailyEventsDict objectForKey:@"id"];
//            dailyEvents.eventName = [dailyEventsDict objectForKey:@"itle"];
//            dailyEvents.eventDescription = [dailyEventsDict objectForKey:@"description"];
//
//            dailyEvents.venueId = [dailyEventsDict objectForKey:@"venue_id"];
//            dailyEvents.venueName = [dailyEventsDict objectForKey:@"venue"];
//            dailyEvents.venueLogo = [dailyEventsDict objectForKey:@"venue_logo"] ;
//
//            // relations
//            dailyEvents.allEvents = allEvents;
//            [dailyEventsArray addObject:dailyEvents];
//
//            // event detail
//            NSString * eventDetailUrl = [NSString stringWithFormat:@"%@%@", kEventDetailUrl, dailyEvents.eventId];
//            NSDictionary *eventDetailDict = [[json toArray:eventDetailUrl] objectAtIndex:0];
//
//            EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:context];
//            eventDetail.date = [eventDetailDict objectForKey:@"date"];
//            eventDetail.eventDescription = [eventDetailDict objectForKey:@"description"];
//            eventDetail.eventId= [eventDetailDict objectForKey:@"id"];
//            eventDetail.eventName = [eventDetailDict objectForKey:@"title"];
//            eventDetail.photo = [eventDetailDict objectForKey:@"photo"];
//
//            eventDetail.venueId = [eventDetailDict objectForKey:@"venue_id"];
//            eventDetail.venueName = [eventDetailDict objectForKey:@"venue"];
//
//            eventDetail.voucherDescription= [eventDetailDict objectForKey:@"voucher_description"];
//            eventDetail.voucherPhoto= [eventDetailDict objectForKey:@"voucher_photo"];
//
//            // relations
//            eventDetail.dailyEvents = dailyEvents;
//            dailyEvents.eventDetail = eventDetail;
//        }
//        // relation
//        allEvents.dailyEvents= [NSSet setWithArray:dailyEventsArray] ;
//
//        //checking if the  data already exists
//        BOOL saveOk = YES;
//        for (AllEvents * lastEvent in lastSaved ) {
//            if ([lastEvent.date isEqualToString:allEvents.date]){
//                saveOk = NO;
//            }
//        }
//
//        //saving data
//        NSError *error = nil;
//        if (saveOk) {
//            if (![context save:&error]) {
//                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//            }
//        }
//        [results addObject:allEvents];
//    }
//    coreDataResults = results;
//}

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
    return [coreDataResults count];
}

// populating the cells of the table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // get the cell
    static NSString *CellIdentifier = @"eventCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }

    // populate
    AllEvents *allEvents =  [coreDataResults objectAtIndex: indexPath.row ];
    cell.titleLabel.text = allEvents.weekDay;

    NSString    *count = allEvents.count;
    if (count ==NULL) {count = @"No" ; }
    cell.descriptionLabel.text = ([NSMutableString stringWithFormat:@"%@ Event(s)", count]);

    NSDictionary *dateDict = [KSUtilities getDateDict:allEvents.date];
    [cell addSubview:[KSUtilities getCalendar:[dateDict objectForKey:@"shortMonth"] forDay:[dateDict objectForKey:@"dateDay"]]];

    // displaying new events as badge
    int newEventCount = [KSBadgeManager countNewEventsOfDate:[NSMutableString stringWithString:allEvents.date] ] ;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AllEvents *allEvents = [coreDataResults objectAtIndex:indexPath.row];

    DailyEventsController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"dailyEvents"];
    nextController.dailyEventsArray = [allEvents.dailyEvents allObjects];
    nextController.date = allEvents.date;

    [self.navigationController pushViewController:nextController  animated: NO];
}

@end
