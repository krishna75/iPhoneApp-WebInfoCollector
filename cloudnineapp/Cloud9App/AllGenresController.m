//
//  AllGenresController.m
//  Cloud9App
//
//  Created by nerd on 11/04/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "AllGenresController.h"
#import "KSJson.h"
#import "AppDelegate.h"
#import "EventsInGenreController.h"
#import "KSCell.h"
#import "AllGenres.h"
#import "EventsInGenre.h"
#import "EventDetail.h"


#define kUrlGenres @"genres.php"
#define kUrlEventsOfGenre @"eventsOfGenre.php?genre_id="
#define kUrlEventDetail @"eventDetail.php?event_id="

#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Preferences"

@interface AllGenresController ()

@end

@implementation AllGenresController {
    
     NSArray *coreDataResults;
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
    if ([json isConnectionAvailable]){
        [self createCoreData:[json toArray:kUrlGenres]];
    } else {
        coreDataResults = [self loadCoreData];
    }
}

- (NSArray *) loadCoreData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllGenres" inManagedObjectContext:context];
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
        AllGenres *allGenres = [NSEntityDescription insertNewObjectForEntityForName:@"AllGenres" inManagedObjectContext:context];
        allGenres.genreId = [jsonDict objectForKey:@"id"];
        allGenres.genreName= [jsonDict objectForKey:@"name"];
        allGenres.genreDescription = [jsonDict objectForKey:@"description"];
        allGenres.genrePhoto = [jsonDict  objectForKey:@"photo"];

        // events in a genre
        NSMutableArray *eventsInGenreArray = [[NSMutableArray alloc] init];
        KSJson * json = [[KSJson alloc] init];
        NSString *jsonURL  = [NSString stringWithFormat:@"%@%@", kUrlEventsOfGenre, allGenres.genreId];
        NSLog(@"AllGrenresController/createCoreData: jsonUrl = %@", jsonURL) ;

        for (NSDictionary *eventsInGenreDict in [json toArray:jsonURL]) {
            EventsInGenre *eventsInGenre = [NSEntityDescription insertNewObjectForEntityForName:@"EventsInGenre" inManagedObjectContext:context];
            eventsInGenre.eventId = [eventsInGenreDict objectForKey:@"event_id"];
            eventsInGenre.date = [eventsInGenreDict objectForKey:@"date"];
            eventsInGenre.eventName = [eventsInGenreDict objectForKey:@"event_title"];

            //relationship
            eventsInGenre.allGenres = allGenres;
            [eventsInGenreArray addObject:eventsInGenre];

            // event detail
            NSDictionary *eventDetailDict = [[json toArray:[NSString stringWithFormat:@"%@%@", kUrlEventDetail, eventsInGenre.eventId]] objectAtIndex:0];

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

            NSLog(@"AllGenreController/createCoreData: eventName=%@",eventDetail.eventName);

            // relationship
            eventDetail.eventsInGenre = eventsInGenre;
            eventsInGenre.eventDetails = eventDetail;
        }
        NSLog(@"AllGenresController/createCoreData: eventsInGenreArray.size = %d", [eventsInGenreArray count]) ;

        //relationship
        allGenres.eventsInGenre = [NSSet setWithArray:eventsInGenreArray] ;

        //checking if the  data already exists
        BOOL saveOk = YES;
        for (AllGenres * lastVenue in lastSaved ) {
            if ([lastVenue.genreId isEqualToString:allGenres.genreId]){
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
        [results addObject:allGenres];
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
    
    return [coreDataResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PrefCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    
    AllGenres *allGenres = [coreDataResults objectAtIndex:indexPath.row];
    cell.titleLabel.text = allGenres.genreName;
    cell.descriptionLabel.text = allGenres.genreDescription;
    [cell addSubview: [KSUtilities getImageViewOfUrl:allGenres.genrePhoto]];
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
    cell.backgroundView = bgView;
    UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
    cell.selectedBackgroundView = selBGView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
//    EventsInGenreController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsInGenre"];
//    nextController.eventsDict = [eventCountDict mutableCopy];
//    nextController.header = [eventCountDict objectForKey:@"genre"];
//    [self.navigationController pushViewController:nextController  animated: NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KSSettings tableCellHeight];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [KSUtilities getHeaderView:NULL forTitle:@"Genres" forDetail:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

@end
