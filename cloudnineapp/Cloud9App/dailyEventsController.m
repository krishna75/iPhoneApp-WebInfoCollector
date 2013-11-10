//
//  dailyEventsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 23/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "dailyEventsController.h"
#import "KSJson.h"
#import "eventDetailsController.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "DailyEvents.h"
#import "AllEvents.h"

#define kjsonURL @"eventsOfADate.php?event_date="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events in a Date"

@interface dailyEventsController ()

@end

@implementation dailyEventsController {
    NSArray *coreDataResults;
}
@synthesize eventDict;
@synthesize allEvents;

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
    [self decorateView];
    [self launchLoadData];
}



#pragma mark - launchLoadData and loadData are for a new thread
-(void)launchLoadData {

    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) loadData {    
    [self processJson];
    [self.tableView reloadData];
    [app RemoveLoadingView];
    [self addRefreshing];
}

// the process also has spinner or loader
- (void)processJson {
    KSJson * json = [[KSJson alloc] init];
    if ([json isConnectionAvailable]) {
        NSString *jsonURL  = [NSString stringWithFormat:@"%@%@",kjsonURL,[eventDict  objectForKey:@"date"]];
        NSArray *jsonResults = [json toArray:jsonURL];
        [self createCoreData:jsonResults];
    } else {
        coreDataResults = [self loadCoreData];
    }
}

- (NSArray *) loadCoreData {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyEvents" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    return [context executeFetchRequest:fetchRequest error:&error];
    return [allEvents.dailyEvents allObjects];
}

- (void)createCoreData: (NSArray *)jsonResults {

    NSArray *lastSaved = [self loadCoreData];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableArray *storableResults = [[NSMutableArray alloc] init];

    //creating and adding a core data object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    for (NSDictionary *dailyEventDict in jsonResults) {
        NSString *eventTitle = [dailyEventDict objectForKey:@"title"];
        NSString *venue = [dailyEventDict objectForKey:@"venue"];
        NSMutableString *strLogoUrl = [dailyEventDict objectForKey:@"venue_logo"];
        NSString *eventId = [dailyEventDict objectForKey:@"id"];
        NSString *date=[dailyEventDict objectForKey:@"date"];

        //creating and adding a core data object
        DailyEvents *dailyEvents = [NSEntityDescription insertNewObjectForEntityForName:@"DailyEvents" inManagedObjectContext:context];

        dailyEvents.eventId = eventId;
        dailyEvents.venueName = venue;
        dailyEvents.eventName = eventTitle;
        dailyEvents.venueLogo = strLogoUrl;
        dailyEvents.date = date;
        dailyEvents.allEvents = allEvents;
        [results addObject:dailyEvents];

        //checking if the  data already exists
        BOOL saveOk = YES;
        for (DailyEvents * lastEvent in lastSaved ) {
            if ([lastEvent.eventId isEqualToString:dailyEvents.eventId]){
                saveOk = NO;
            }
        }
        if (saveOk) {
            [storableResults addObject:dailyEvents];
        }
    }
   
    coreDataResults = results;
    allEvents.dailyEvents = [NSSet setWithArray:storableResults];

    //saving data
    NSError *error = nil;

    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


- (void)decorateView{
    
    //back button
    [self setBackButton];
    
    // background
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
    self.navigationController.topViewController.title  = kTitle;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"eventCell2";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    DailyEvents * dailyEvents = [coreDataResults objectAtIndex:indexPath.row];
    cell.titleLabel.text = dailyEvents.eventName;
    cell.descriptionLabel.text = dailyEvents.venueName;
    [cell addSubview: [KSUtilities getImageViewOfUrl:dailyEvents.venueLogo]];
    
    //displaying new events as badge
    NSString    *eventId = dailyEvents.eventId;
    NSString    *date= dailyEvents.date;
    NSMutableString *eventIdDate = [NSString stringWithFormat:@"%@:%@",eventId,date];
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

#pragma mark - Table header for the view

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dateDict =[KSUtilities getDateDict:[eventDict objectForKey:@"date"]] ;
    NSMutableString *title = [dateDict objectForKey:@"longMonth"];
    NSString *description = [NSString stringWithFormat:@"%@%@ %@",[dateDict objectForKey:@"dateDay"],[
            dateDict objectForKey:@"suffix"], [dateDict objectForKey:@"weekDay"]];
    
    return [KSUtilities getHeaderView:NULL forTitle:title forDetail:description];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DailyEvents *dailyEvents = [coreDataResults objectAtIndex:indexPath.row];
//
//    eventDetailsController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
//    nextViewController.eventId = dailyEvents.eventId;
//    nextViewController.dailyEvents = dailyEvents;
//
//    [self.navigationController pushViewController:nextViewController animated: NO];
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
