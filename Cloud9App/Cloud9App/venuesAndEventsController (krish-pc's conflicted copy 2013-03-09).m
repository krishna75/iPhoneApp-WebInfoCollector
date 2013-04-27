//
//  venuesAndEventsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 24/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "venuesAndEventsController.h"

#import <QuartzCore/QuartzCore.h>
#import "KrishnaCell.h"
#import "MyJson.h"
#import "eventsInAVenueController.h"

#define kjsonURL @"http://www.chitwan-abroad.org/cloud9/venuesAndEvents.php"
#define kTableBG @"bg_tableView.png"
#define kCellBG @"bg_cell.png"
#define kCellSelectedBG @"bg_cellSelected.png"
#define kTitle @" Venues"


@interface venuesAndEventsController ()

@end

@implementation venuesAndEventsController {
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
    [self processJson];
    
}

- (void)processJson {
    MyJson * json = [[MyJson alloc] init];
    jsonResults = [json toArray:kjsonURL];
}

- (void)decorateView{
    
    //table view title
    self.navigationController.topViewController.title  = kTitle;
    
    //back button
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"style:UIBarButtonItemStyleBordered target:nil action:nil] ;
    
    // table view background image
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
    NSString    *venueName = [eventCountDict objectForKey:@"name"];
    NSString    *venueAddress = [eventCountDict objectForKey:@"address"];
    NSString    *count = [eventCountDict objectForKey:@"quantity"];
    NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Event(s)",count];
    
    NSURL *imageURL = [NSURL URLWithString:[eventCountDict objectForKey:@"logo"]];
    NSData  *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *logoImage = [[UIImage alloc] initWithData:imageData];
    
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
    
    cell.titleLabel.text = venueName;
    cell.subTitleLabel.text = venueAddress;
    cell.descriptionLabel.text = countDetail;
    cell.cellImage.image = logoImage;
    
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
    NSString *venueId = [eventCountDict objectForKey:@"venue_id"];
    NSString    *venueName = [eventCountDict objectForKey:@"name"];
    NSString    *venueAddress = [eventCountDict objectForKey:@"address"];
    
    NSURL *imageURL = [NSURL URLWithString:[eventCountDict objectForKey:@"logo"]];
    NSData  *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *logoImage = [[UIImage alloc] initWithData:imageData];
    
    NSMutableDictionary *venueDict = [[NSMutableDictionary alloc] init];
    [venueDict setObject:venueId forKey:@"venue_id"];
    [venueDict setObject:venueName forKey:@"name"];
    [venueDict setObject:venueAddress forKey:@"address"];
    [venueDict setObject:logoImage forKey:@"logo"];
    
    
    eventsInAVenueController *nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsInAVenue"];
    
    // this assumes that you only have one section in your table
    nextController.venueDict = venueDict;
    
    [self.navigationController pushViewController:nextController  animated: NO];    
}

@end
