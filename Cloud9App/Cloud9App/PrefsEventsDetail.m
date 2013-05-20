//
//  PrefsEventsDetail.m
//  Cloud9App
//
//  Created by nerd on 19/04/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "PrefsEventsDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "KrishnaCell.h"
#import "MyJson.h"
#import "eventDetailsController.h"
#import "NSUtilities.h"
#import "BadgeManager.h"
#import "AppDelegate.h"

#define kjsonURL @"eventsOfGenre.php?subgenre_id="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Preferences"


@interface PrefsEventsDetail ()

@end

@implementation PrefsEventsDetail {
    
    NSMutableArray *jsonResults;
}
@synthesize eventsDict = _eventsDict;
@synthesize header = _header;

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
#pragma mark - launchLoadData and loadData are for a new thread

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
    NSString *url  = [NSString stringWithFormat:@"%@%@",kjsonURL,[_eventsDict  objectForKey:@"genre_id"]];
    NSLog(@"url %@",url);
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    jsonResults = [json toArray:urlString];
    NSLog(@"jsonResults >> %@",jsonResults);
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
    
    KrishnaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"prefseventCell"];
    
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[[jsonResults objectAtIndex:indexPath.row] objectForKey:@"event_title"]];
    NSString *date = [NSString stringWithFormat:@"%@",[[jsonResults objectAtIndex:indexPath.row]
                                                       objectForKey:@"date"]];
    NSString *day = [NSString stringWithFormat:@"%@",[[jsonResults objectAtIndex:indexPath.row]
                                                      objectForKey:@"day"]];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@,%@",date,day];
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
    
    NSString *title = [NSString stringWithFormat:@"%@",self.header];
    return [NSUtilities getHeaderView:nil forTitle:title forDetail:title];
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
