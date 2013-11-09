//
//  eventController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "eventController.h"

#import <QuartzCore/QuartzCore.h>
#import "KrishnaCell.h"
#import "MyJson.h"
#import "dailyEventsController.h"

#define kjsonURL @"http://www.chitwan-abroad.org/cloud9/datesAndEvents.php"
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @"Events"



@interface eventController ()

@end

@implementation eventController {
    
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
    jsonResults = [json toArray:kjsonURL];
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
    NSString    *day = [eventCountDict objectForKey:@"day"];
    NSString    *date = [eventCountDict objectForKey:@"date"];
    NSString    *count = [eventCountDict objectForKey:@"quantity"];
    NSMutableString *dayDate = [NSMutableString stringWithFormat:@"%@, %@",day,date];
    NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Events",count];
    
    cell.titleLabel.text = dayDate;
    cell.descriptionLabel.text = countDetail;
    
    // rounded border
//    UIImageView *imageView = cell.cellImage;
//    imageView.layer.cornerRadius = 10;
//    imageView.layer.borderWidth = 3;
//    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //shadow

    
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellBG] ];
   cell.backgroundView = bgView;

  UIImageView *selBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCellSelectedBG]];
  cell.selectedBackgroundView = selBGView;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *eventCountDict = [jsonResults objectAtIndex:indexPath.row];
    NSString    *day = [eventCountDict objectForKey:@"day"];
    NSString    *date = [eventCountDict objectForKey:@"date"];
    NSString    *count = [eventCountDict objectForKey:@"quantity"];
    NSMutableString *dayDate = [NSMutableString stringWithFormat:@"%@, %@",day,date];
    NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Events",count];
    
    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc]init];
    [eventDict setObject:date forKey:@"date"];
    [eventDict setObject:dayDate forKey:@"dayDate"];
    [eventDict setObject:countDetail forKey:@"countDetail"];
    
    
    dailyEventsController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"dailyEvents"];
    
    // this assumes that you only have one section in your table
    nextController.eventDict = eventDict;
    
    [self.navigationController pushViewController:nextController  animated: NO];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    // Set title
    self.navigationItem.title=@"Original Title";
}

-(void)viewWillDisappear:(BOOL)animated {
    
    // Set title
    self.navigationItem.title=@"Back";
}

@end
