//
//  KSAllGenresController.m
//  Cloud9App
//
//  Created by nerd on 11/04/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSAllGenresController.h"
#import "KSJson.h"
#import "AppDelegate.h"
#import "KSEventsInGenreController.h"
#import "KSCell.h"
#import "KSAllGenres.h"
#import "KSEventsInGenre.h"
#import "KSEventDetail.h"
#import "KSCoreDataManager.h"

#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Preferences"

@interface KSAllGenresController ()

@end

@implementation KSAllGenresController {
    
     NSArray *coreDataResults;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [app AddloadingView];
    [self launchLoadData];
    [self decorateView];
    [self addRefreshing];
}

-(void)launchLoadData {
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) loadData {
    [self processJson];
    [self.tableView reloadData];
    [app RemoveLoadingView];
}

- (void)processJson {
    [KSCoreDataManager createGenres];
    coreDataResults = [KSCoreDataManager getGenres];
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
    self.navigationController.navigationBar.topItem.title  = @"Preferences";
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
    
    return [coreDataResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PrefCell1";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] ;
    }
    
    KSAllGenres *allGenres = [coreDataResults objectAtIndex:indexPath.row];
    cell.titleLabel.text = allGenres.genreName;
    cell.descriptionLabel.text = allGenres.genreDescription;
    [cell addSubview: [KSUtilities getImageViewOfUrl:allGenres.genrePhoto]];
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [KSUtilities getHeaderView:NULL forTitle:@"Genres" forDetail:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    KSAllGenres *allGenres = [coreDataResults objectAtIndex:indexPath.row];

    KSEventsInGenreController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsInGenre"];

    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    nextController.eventsInGenreArray = [[allGenres.eventsInGenre allObjects] sortedArrayUsingDescriptors:sortDescriptors];

    nextController.genreName= allGenres.genreName;
    nextController.genreDescription= allGenres.genreDescription;
    nextController.genrePhoto= allGenres.genrePhoto;

    [self.navigationController pushViewController:nextController  animated: NO];
}

@end
