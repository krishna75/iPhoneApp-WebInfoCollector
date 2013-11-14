//
//  EventsInGenreController.m
//  Cloud9App
//
//  Created by nerd on 19/04/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "EventsInGenreController.h"
#import <QuartzCore/QuartzCore.h>
#import "KSJson.h"
#import "EventDetailsController.h"
#import "KSUtilities.h"
#import "KSBadgeManager.h"
#import "AppDelegate.h"
#import "KSCell.h"
#import "KSSettings.h"
#import "EventsInGenre.h"

#define kUrlEventsOfGenre @"eventsOfGenre.php?genre_id="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Preferences"


@interface EventsInGenreController ()

@end

@implementation EventsInGenreController {
    
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
    
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
#pragma mark - launchLoadData and loadData are for a new thread

-(void)launchLoadData {
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) loadData {
    [self.tableView reloadData];
    [app RemoveLoadingView];
}



- (void)decorateView{
    
    [self setBackButton];
    
    //tableview background image
    UIGraphicsBeginImageContext(self.tableView.frame.size);
    [[UIImage imageNamed:kTableBG] drawInRect:self.tableView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:image];
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
    return [_eventsInGenreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PrefCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }

    EventsInGenre *eventsInGenre = [_eventsInGenreArray objectAtIndex:indexPath.row];

    cell.titleLabel.text = eventsInGenre.eventName;
    NSString *date = eventsInGenre.date;
    NSString *day = eventsInGenre.weekDay;

    NSDictionary *dateDict = [KSUtilities getDateDict:date];
    [cell addSubview: [KSUtilities getCalendar:[dateDict objectForKey:@"shortMonth"] forDay:[dateDict objectForKey:@"dateDay"]]];
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
    cell.backgroundView = bgView;
    
    UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
    cell.selectedBackgroundView = selBGView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KSSettings tableCellHeight];
}



// header for the table view controller
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    

    return [KSUtilities getHeaderView:[KSUtilities getImage:_genrePhoto] forTitle:_genreName forDetail:_genreDescription];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *appsDict = [jsonResults objectAtIndex:indexPath.row];
//    NSString *eventId = [appsDict objectForKey:@"event_id"];
//
//    EventDetailsController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
//    nextViewController.eventId = eventId;
//
//    [self.navigationController pushViewController:nextViewController animated: NO];

}
@end
