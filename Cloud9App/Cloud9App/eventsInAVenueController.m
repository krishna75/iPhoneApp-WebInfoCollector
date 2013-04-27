//
//  eventsInAVenueController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "eventsInAVenueController.h"

#import <QuartzCore/QuartzCore.h>
#import "KrishnaCell.h"
#import "MyJson.h"
#import "eventDetailsController.h"
#import "NSUtilities.h"
#import "BadgeManager.h"

#define kjsonURL @"http://www.chitwan-abroad.org/cloud9/eventsOfAVenue.php?venue_id="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events"

@interface eventsInAVenueController ()

@end

@implementation eventsInAVenueController {
    NSMutableArray *jsonResults;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self launchLoadData];
    [self decorateView];  
}
#pragma mark - launchLoadData and loadData are for a new thread
-(void)launchLoadData {
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}


- (void) loadData {
    [self processJson];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil    waitUntilDone:NO];
}

// the process also has spinner or loader
- (void)processJson {
    
    //loading... spinnner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:self.view.center];
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // the actuatl process
    MyJson * json = [[MyJson alloc] init];
    NSString *jsonURL  = [NSString stringWithFormat:@"%@%@",kjsonURL,[_venueDict objectForKey:@"venue_id" ]];
    jsonResults = [json toArray:jsonURL];
    
    [spinner stopAnimating];
    
}

- (void)decorateView{
    
    [self setBackButton];
    //self.navigationController.topViewController.title  = kTitle;
    
    //tableview background image
    UIGraphicsBeginImageContext(self.tableView.frame.size);
    [[UIImage imageNamed:kTableBG] drawInRect:self.tableView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:image];
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
    return [jsonResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KrishnaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"venue2Cell"];
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    NSString    *date = [eventCountDict objectForKey:@"date"];
    NSString    *eventTitle = [eventCountDict objectForKey:@"event_title"];

    cell.titleLabel.text = eventTitle;
    cell.descriptionLabel.text = [NSUtilities getFormatedDate:date];
    
    //displaying new events as badge
    NSString    *eventId = [eventCountDict objectForKey:@"event_id"];
    NSMutableString *eventIdDate = [NSString stringWithFormat:@"%@:%@",eventId,date];
    if ([BadgeManager isNewEvent:eventIdDate]) {
        [cell addSubview:[NSUtilities getBadgeLikeView:[NSString stringWithFormat:@"new"]]];
    }
    
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
    cell.backgroundView = bgView;
    
    UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
    cell.selectedBackgroundView = selBGView;
    
}

// header for the table view controller
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImage *logoImage = [_venueDict objectForKey:@"logo"];
    NSString *title =  [_venueDict objectForKey:@"name"];
    NSString *description = [_venueDict objectForKey:@"address"];
    
    return [NSUtilities getHeaderView:logoImage forTitle:title forDetail:description];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *appsDict = [jsonResults objectAtIndex:indexPath.row];
    NSString *eventId = [appsDict objectForKey:@"event_id"];
    
    eventDetailsController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    nextViewController.eventId = eventId;
    
    [self.navigationController pushViewController:nextViewController animated: NO];
    
}

#pragma mark - Back button;
-(void) setBackButton {
    UIButton *btn = [NSUtilities getBackButon];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
