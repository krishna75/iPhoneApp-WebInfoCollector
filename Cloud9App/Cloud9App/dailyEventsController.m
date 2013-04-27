//
//  dailyEventsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 23/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "dailyEventsController.h"

#import <QuartzCore/QuartzCore.h>
#import "KrishnaCell.h"
#import "MyJson.h"
#import "eventDetailsController.h"
#import "NSUtilities.h"
#import "BadgeManager.h"

#define kjsonURL @"http://www.chitwan-abroad.org/cloud9/eventsOfADate.php?event_date="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events"
#define kBackButton @"backButton.png"

@interface dailyEventsController ()

@end

@implementation dailyEventsController {
    
    NSMutableArray *jsonResults;
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
    NSString *jsonURL  = [NSString stringWithFormat:@"%@%@",kjsonURL,[_eventDict  objectForKey:@"date"]];
    jsonResults = [json toArray:jsonURL];
    
    [spinner stopAnimating];
    
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
    return [jsonResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KrishnaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"event2Cell"];
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    NSString    *eventTitle = [eventCountDict objectForKey:@"title"];
    NSString    *venue = [eventCountDict objectForKey:@"venue"];
    NSMutableString *logo = [eventCountDict objectForKey:@"venue_logo"];
    
    cell.titleLabel.text = eventTitle;
    cell.descriptionLabel.text = venue;
    [cell addSubview: [NSUtilities getImageViewOfUrl:logo]];
    
    //displaying new events as badge
    NSString    *eventId = [eventCountDict objectForKey:@"id"];
    NSString    *date= [eventCountDict objectForKey:@"date"];
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

#pragma mark - Table header for the view

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSMutableString *title = [_eventDict objectForKey:@"formattedDate"];
    NSMutableString *description = [_eventDict objectForKey:@"countDetail"];
    
    return [NSUtilities getHeaderView:NULL forTitle:title forDetail:description];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *appsDict = [jsonResults objectAtIndex:indexPath.row];
    NSString *eventId = [appsDict objectForKey:@"id"];
    
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
