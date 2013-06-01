//
//  preferencesEvents.m
//  Cloud9App
//
//  Created by nerd on 12/04/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "preferencesEvents.h"
#import <QuartzCore/QuartzCore.h>
#import "KrishnaCell.h"
#import "MyJson.h"
#import "dailyEventsController.h"
#import "NSUtilities.h"
#import "FirstJsonLoader.h"
#import "BadgeManager.h"
#import "AppDelegate.h"
#import "PrefsEventsDetail.h"


#define kjsonURL @"subgenres.php?genre_id="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Preferences"
#define kBackButton @"backButton.png"

@interface preferencesEvents ()

@end

@implementation preferencesEvents {
    
    NSMutableArray *jsonResults;
}

//@synthesize eventDict;

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
    
    MyJson * json = [[MyJson alloc] init];
    NSString *url  = [NSString stringWithFormat:@"%@%@",kjsonURL,[_eventDict  objectForKey:@"id"]];
    NSString *jsonURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"pref 2: jsonURL >> %@",jsonURL);
    jsonResults = [json toArray:jsonURL];
    NSLog(@"pref 2: jsonResults >> %@",jsonResults);
    [self.tableView reloadData];
}

- (void)decorateView {
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:kTableBG] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title  = kTitle;
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
    
    static NSString *CellIdentifier = @"prefEventCell";
    KrishnaCell * cell = (KrishnaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",[eventCountDict valueForKey:@"subgenre"]];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@",[eventCountDict valueForKey:@"description"]];
    [cell addSubview: [NSUtilities getImageViewOfUrl:[eventCountDict objectForKey:@"photo"]]];
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
    cell.backgroundView = bgView;
    
    UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
    cell.selectedBackgroundView = selBGView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSMutableString *title = [NSString stringWithFormat:@"%@",@"Sub Genres"];
    return [NSUtilities getHeaderView:NULL forTitle:title forDetail:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 70;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    PrefsEventsDetail *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrefsEventDetail"];
    nextController.eventsDict = [eventCountDict mutableCopy];
    nextController.header = [eventCountDict objectForKey:@"subgenre"];
    [self.navigationController pushViewController:nextController  animated: NO];

    //PrefsEventDetail
}

@end
