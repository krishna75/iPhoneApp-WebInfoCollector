//
//  preferencesController.m
//  Cloud9App
//
//  Created by nerd on 11/04/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "preferencesController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyJson.h"
#import "dailyEventsController.h"
#import "NSUtilities.h"
#import "FirstJsonLoader.h"
#import "BadgeManager.h"
#import "AppDelegate.h"
#import "preferencesEvents.h"
#import "KSCell.h"
#import "KSSettings.h"

#define kjsonURL @"genres.php"
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Preferences"

@interface preferencesController ()

@end

@implementation preferencesController {
    
     NSMutableArray *jsonResults;
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
    jsonResults = [json toArray:kjsonURL];
    NSLog(@"prefController processJson: jsonResults %@",jsonResults);
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
    
    static NSString *CellIdentifier = @"PrefCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    NSMutableString    *genre = [eventCountDict objectForKey:@"genre"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", genre];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@",[eventCountDict objectForKey:@"description"]];
    [cell addSubview: [NSUtilities getImageViewOfUrl:[eventCountDict objectForKey:@"photo"]]];
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
    cell.backgroundView = bgView;
    UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
    cell.selectedBackgroundView = selBGView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    preferencesEvents *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"prefEvents"];
    nextController.eventDict = [eventCountDict mutableCopy];
    [self.navigationController pushViewController:nextController  animated: NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KSSettings tableCellHeight];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSMutableString *title = [NSString stringWithFormat:@"%@",@"Genres"];
    return [NSUtilities getHeaderView:NULL forTitle:title forDetail:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 70;
}

@end
