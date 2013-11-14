//
//  AllGenresController.m
//  Cloud9App
//
//  Created by nerd on 11/04/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "AllGenresController.h"
#import <QuartzCore/QuartzCore.h>
#import "KSJson.h"
#import "DailyEventsController.h"
#import "KSUtilities.h"
#import "FirstJsonLoader.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "EventsInGenreController.h"
#import "KSCell.h"
#import "KSSettings.h"

#define kjsonURL @"genres.php"
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Preferences"

@interface AllGenresController ()

@end

@implementation AllGenresController {
    
     NSMutableArray *jsonResults;
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [app AddloadingView];
    [self launchLoadData];
    [self decorateView];
    [self addRefreshing];
}

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
    jsonResults = [json toArray:kjsonURL];
}

- (NSArray *) loadCoreData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllGenresController" inManagedObjectContext:context];
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

        //all genres
        AllVenues *allVenues = [NSEntityDescription insertNewObjectForEntityForName:@"AllGenresController" inManagedObjectContext:context];
        allVenues.date = [jsonDict objectForKey:@"date"];
        allVenues.venueId = [jsonDict objectForKey:@"venue_id"];
        allVenues.venueName = [jsonDict objectForKey:@"name"];
        allVenues.venueAddress = [jsonDict  objectForKey:@"address"];
        allVenues.venueLogo = [jsonDict objectForKey:@"logo"];
        NSMutableString *quantity = [jsonDict objectForKey:@"quantity"];
        allVenues.eventCountDetail = [NSMutableString stringWithFormat:@"%@ Event(s)",quantity];

        // events in a genre
        NSMutableArray *eventsInVenueArray = [[NSMutableArray alloc] init];
        KSJson * json = [[KSJson alloc] init];
        NSString *jsonURL  = [NSString stringWithFormat:@"%@%@", kEventsOfVenueUrl, allVenues.venueId];
        NSLog(@"AllVenuesController/createCoreData: jsonUrl = %@", jsonURL) ;
        for (NSDictionary *eventsInVenueDict in [json toArray:jsonURL]) {
            EventsInVenue *eventsInVenue = [NSEntityDescription insertNewObjectForEntityForName:@"EventsInVenue" inManagedObjectContext:context];
            eventsInVenue.eventId = [eventsInVenueDict objectForKey:@"event_id"];
            eventsInVenue.date = [eventsInVenueDict objectForKey:@"date"];
            eventsInVenue.eventName = [eventsInVenueDict objectForKey:@"event_title"];
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

            eventDetail.eventsInVenue = eventsInVenue;
            eventsInVenue.eventDetails = eventDetail;
        }
        NSLog(@"AllVenuesController/createCoreData: eventsInVenueArray.size = %d", [eventsInVenueArray count]) ;
        allVenues.eventsInVenue = [NSSet setWithArray:eventsInVenueArray] ;

        //checking if the  data already exists
        BOOL saveOk = YES;
        for (AllVenues * lastVenue in lastSaved ) {
            if ([lastVenue.eventId isEqualToString:allVenues.eventId]){
                saveOk = NO;
            }
        }

        //saving data
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
    self.navigationController.navigationBar.topItem.title  = @"Preferences";
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [jsonResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PrefCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    NSMutableString    *genre = [eventCountDict objectForKey:@"genre"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", genre];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@",[eventCountDict objectForKey:@"description"]];
    [cell addSubview: [KSUtilities getImageViewOfUrl:[eventCountDict objectForKey:@"photo"]]];
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
    cell.backgroundView = bgView;
    UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
    cell.selectedBackgroundView = selBGView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    EventsInGenreController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsInGenre"];
    nextController.eventsDict = [eventCountDict mutableCopy];
    nextController.header = [eventCountDict objectForKey:@"genre"];
    [self.navigationController pushViewController:nextController  animated: NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KSSettings tableCellHeight];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSMutableString *title = [NSString stringWithFormat:@"%@",@"Genres"];
    return [KSUtilities getHeaderView:NULL forTitle:title forDetail:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 70;
}

@end
