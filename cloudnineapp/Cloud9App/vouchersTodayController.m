//
//  AllVenuesController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "VouchersTodayController.h"
#import "KSJson.h"
#import "VoucherDetailController.h"
#import "KSUtilities.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "KSSettings.h"
#import "VouchersToday.h"

#define kUrlVoucher @"vouchers.php"
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"


@interface VouchersTodayController ()

@end

@implementation VouchersTodayController {
    NSArray *coreDataResults;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

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
    KSJson * json = [[KSJson alloc] init];
    if ([json isConnectionAvailable]){
        [self createCoreData:[json toArray:kUrlVoucher]];
    } else {
        coreDataResults = [self loadCoreData];
    }
}

- (NSArray *) loadCoreData {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VouchersToday" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

- (void) createCoreData: (NSArray *) jsonResults {

    NSArray *lastSaved = [self loadCoreData];
    NSMutableArray *results = [[NSMutableArray alloc] init] ;

    // get the context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    for (NSDictionary *jsonDict in jsonResults) {

        // vouchers today
        VouchersToday *vouchersToday = [NSEntityDescription insertNewObjectForEntityForName:@"VouchersToday" inManagedObjectContext:context];
        vouchersToday.venueId = [jsonDict objectForKey:@"venue_id"];
        vouchersToday.venueName= [jsonDict objectForKey:@"name"];
        vouchersToday.venueAddress = [jsonDict objectForKey:@"address"];
        vouchersToday.venueLogo= [jsonDict  objectForKey:@"logo"];
        vouchersToday.eventId= [jsonDict  objectForKey:@"event_id"];
        vouchersToday.eventName= [jsonDict  objectForKey:@"event_title"];
        vouchersToday.voucherDescription= [jsonDict  objectForKey:@"voucher_description"];
        vouchersToday.voucherPhoto= [jsonDict  objectForKey:@"voucher_photo"];

        // event details
        EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:context];
        eventDetail.venueId = vouchersToday.venueId;
        eventDetail.venueName = vouchersToday.venueName;
        eventDetail.eventId = vouchersToday.eventId;
        eventDetail.eventName = vouchersToday.eventName;
        eventDetail.voucherDescription = vouchersToday.voucherDescription ;
        eventDetail.voucherPhoto = vouchersToday.voucherPhoto;

        // adding today's date  to the event details
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"YYYY-MM-dd"];
        NSString *todayString = [dateFormat stringFromDate:today];
        eventDetail.date = todayString;

        // relations
        eventDetail.vouchersToday = vouchersToday;
        vouchersToday.eventDetails = eventDetail;

        // checking if the  data already exists
        BOOL saveOk = YES;
        for (VouchersToday *lastVoucher in lastSaved ) {
            if ([lastVoucher.eventId isEqualToString:vouchersToday.eventId]){
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
        [results addObject:vouchersToday];
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
    self.navigationController.navigationBar.topItem.title  = @"Vouchers";
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {[super viewWillDisappear:animated];}
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return [coreDataResults count];}


// data for the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"venueCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    
    VouchersToday *vouchersToday = [coreDataResults objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = vouchersToday.venueName;
    cell.moreLabel.text = vouchersToday.voucherDescription;
    cell.descriptionLabel.text = vouchersToday.eventName;
    [cell addSubview: [KSUtilities getImageViewOfUrl:vouchersToday.venueLogo]];

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

    VouchersToday *vouchersToday = [coreDataResults objectAtIndex:indexPath.row];

    VoucherDetailController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"voucher"];
    nextViewController.eventDetail= vouchersToday.eventDetails;

    [self.navigationController pushViewController:nextViewController animated:NO];
}

@end
