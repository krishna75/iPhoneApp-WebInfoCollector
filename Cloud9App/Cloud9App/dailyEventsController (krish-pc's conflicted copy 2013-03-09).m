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

#define kjsonURL @"http://www.chitwan-abroad.org/cloud9/eventsOfADate.php?event_date="
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events"

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
    [self processJson];
    [self decorateView];
}

- (void)processJson {
    MyJson * json = [[MyJson alloc] init];
    NSString *jsonURL  = [NSString stringWithFormat:@"%@%@",kjsonURL,[_eventDict  objectForKey:@"date"]];
    jsonResults = [json toArray:jsonURL];
}

- (void)decorateView{
    self.navigationController.topViewController.title  = kTitle;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:kTableBG] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
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
    
    KrishnaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    NSString    *eventTitle = [eventCountDict objectForKey:@"title"];
    NSString    *venue = [eventCountDict objectForKey:@"venue"];
    
    // rounded border
    UIImageView *imageView = cell.cellImage;
    imageView.layer.cornerRadius = 10;
    imageView.layer.borderWidth = 3;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //shadow
    imageView.layer.shadowColor = [UIColor grayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(5, 5);
    imageView.layer.shadowOpacity = 1;
    imageView.layer.shadowRadius = 10;
    imageView.clipsToBounds = YES;
  
    
    cell.titleLabel.text = eventTitle;
    cell.descriptionLabel.text = venue;
    
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
    cell.backgroundView = bgView;
    
    UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
    cell.selectedBackgroundView = selBGView;
    
}

//#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *appsDict = [jsonResults objectAtIndex:indexPath.row];
    NSString *eventId = [appsDict objectForKey:@"id"];
    
    
    eventDetailsController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    
    // this assumes that you only have one section in your table
    nextViewController.eventId = eventId;
    
    [self.navigationController pushViewController:nextViewController animated: NO];
    
    
}


// header for the view

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10,0,300,60)] ;
    
    UIGraphicsBeginImageContext(customView.frame.size);
    [[UIImage imageNamed:@"bg_tableViewHeader.png"] drawInRect:customView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    customView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // create the label objects
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.frame = CGRectMake(70,18,200,20);
    headerLabel.text =  [_eventDict objectForKey:@"dayDate"];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.text = [_eventDict objectForKey:@"countDetail"];
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.frame = CGRectMake(70,33,230,25);
    
    // create the imageView with the image in it
    UIImage *myImage = [UIImage imageNamed:@"icon.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(10,10,50,50);
    
    [customView addSubview:imageView];
    [customView addSubview:headerLabel];
    [customView addSubview:detailLabel];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}



@end
