//
//  KSDailyEventsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 23/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSDailyEventsController.h"
#import "KSEventDetailsController.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "KSDailyEvents.h"
#import "KSUtilities.h"
#import "KSSettings.h"

#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events in a Date"

@interface KSDailyEventsController ()

@end

@implementation KSDailyEventsController {

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {}
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
    [self.tableView reloadData];
    [app RemoveLoadingView];
    [self addRefreshing];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return [_dailyEventsArray count];}

// populate the cells in the table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // get cell
    static NSString *CellIdentifier = @"eventCell2";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }

    // populate
    KSDailyEvents * dailyEvents = [_dailyEventsArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = dailyEvents.eventName;
    cell.descriptionLabel.text = dailyEvents.venueName;
    [cell addSubview: [KSUtilities getImageViewOfUrl:dailyEvents.venueLogo]];
    
    // displaying new events as badge
    UIView *badge = [cell viewWithTag:111];
    [badge removeFromSuperview];
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

#pragma mark - Table header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dateDict =[KSUtilities getDateDict:_date] ;
    NSMutableString *title = [dateDict objectForKey:@"longMonth"];
    NSString *description = [NSString stringWithFormat:@"%@%@ %@",[dateDict objectForKey:@"dateDay"],[
            dateDict objectForKey:@"suffix"], [dateDict objectForKey:@"weekDay"]];
    
    return [KSUtilities getHeaderView:NULL forTitle:title forDetail:description];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KSDailyEvents *dailyEvents = [_dailyEventsArray objectAtIndex:indexPath.row];

    KSEventDetailsController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    nextViewController.eventDetail= dailyEvents.eventDetail;

    [self.navigationController pushViewController:nextViewController animated: NO];
}
@end
