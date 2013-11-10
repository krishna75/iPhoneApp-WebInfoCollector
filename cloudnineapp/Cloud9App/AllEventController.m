//
//  AllEventController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "AllEventController.h"

#import "KSJson.h"
#import "dailyEventsController.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"


#define kjsonURL @"datesAndEvents.php"
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events"



@interface AllEventController ()

@end

@implementation AllEventController {
    NSArray *coreDataResults;
}
@synthesize managedObjectContext;

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

// the process also has spinner or loader
- (void)processJson {
    KSJson * json = [[KSJson alloc] init];
    if ([json isConnectionAvailable]){
        NSArray * jsonResults = [json toArray:kjsonURL];
        [self createCoreData: jsonResults];
    } else {
      coreDataResults = [self loadCoreData];
    }
}

- (NSArray *) loadCoreData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllEvents" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

- (void) createCoreData: (NSArray *) jsonResults {
    NSArray *lastSaved = [self loadCoreData];
    NSMutableArray *results = [[NSMutableArray alloc] init] ;
    for (NSDictionary * eventCountDict in jsonResults) {

        NSMutableString    *date = [eventCountDict objectForKey:@"date"];
        NSString    *count = [eventCountDict objectForKey:@"quantity"];
        if (count == nil) {count = @"No" ; }
        NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Event(s)",count];
        NSDictionary *dateDict = [KSUtilities getDateDict:date];
        //computing and displaying new events as badge
        int newEventCount = [KSBadgeManager countNewEventsOfDate:date];

        //creating and adding a core data object
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        AllEvents *allEvents = [NSEntityDescription insertNewObjectForEntityForName:@"AllEvents" inManagedObjectContext:context];

        allEvents.dateDay = [NSNumber numberWithInt:[[dateDict objectForKey:@"dateDay"] intValue]];
        allEvents.weekDay = [dateDict objectForKey:@"weekDay"];
        allEvents.shortMonth = [dateDict objectForKey:@"shortMonth"];
        allEvents.eventDate = date;
        allEvents.eventCountDetails= countDetail;
        allEvents.numNewEvents = [NSNumber numberWithInt:newEventCount];

        //checking if the  data already exists
        BOOL saveOk = YES;
        for (AllEvents * lastEvent in lastSaved ) {
            if ([lastEvent.eventDate isEqualToString:allEvents.eventDate]){
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
        [results addObject:allEvents];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"eventCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }

    AllEvents *allEvents =  [coreDataResults objectAtIndex: indexPath.row ];
    cell.titleLabel.text = allEvents.weekDay;
    cell.descriptionLabel.text = allEvents.eventCountDetails;
    [cell addSubview: [KSUtilities getCalendar:allEvents.shortMonth forDay:[allEvents.dateDay stringValue]]];
    
    //displaying new events as badge
    int newEventCount = allEvents.numNewEvents.intValue;
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
    AllEvents *allEvents = [coreDataResults objectAtIndex:indexPath.row];

    NSMutableString    *formattedDate = [KSUtilities getFormatedDate:allEvents.eventDate];
    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc]init];
    [eventDict setObject:allEvents.eventDate forKey:@"date"];
    [eventDict setObject:formattedDate forKey:@"formattedDate"];
    [eventDict setObject:allEvents.eventCountDetails forKey:@"countDetail"];

    dailyEventsController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"dailyEvents"];
    nextController.eventDict = eventDict;
    nextController.allEvents = allEvents;

    [self.navigationController pushViewController:nextController  animated: NO];
}





@end
