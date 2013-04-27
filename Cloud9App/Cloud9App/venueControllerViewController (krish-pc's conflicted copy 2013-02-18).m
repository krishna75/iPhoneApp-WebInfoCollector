//
//  venueControllerViewController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "venueControllerViewController.h"
#import "KrishnaCell.h"
#define kBgQueue  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kjsonURL [NSURL URLWithString: @"http://www.chitwan-abroad.org/cloud9/venues.php"]



@implementation venueControllerViewController {
  
    NSArray *jsonResults;
}


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    // Custom initialization


    
//        NSLog(@"size of the results: %i", [jsonResults count]);
//
    if (self) {
        
        
        
        
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: kjsonURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void) fetchedData: (NSData *) responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    jsonResults = json;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    KrishnaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...*
    NSDictionary* appsDict = [jsonResults objectAtIndex:indexPath.row];
    
    NSURL *imageURL = [NSURL URLWithString:[appsDict objectForKey:@"logo"]];
    NSData  *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    cell.titleLabel.text = [appsDict objectForKey:@"name"];
    cell.descriptionLabel.text = [appsDict objectForKey:@"address"];
    cell.cellImage.image = image;
    
    
    return cell;
}

- (void) tableView:(UITableViewCell *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithPatternImage:[uiimage imageNamed:@"T"]];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *appsDict = [jsonResults objectAtIndex:indexPath.row];
    NSString *appURL = [appsDict objectForKey:@"trackViewURl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
    
    
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     *detailViewController = [[ alloc] initWithNibName:@"" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
