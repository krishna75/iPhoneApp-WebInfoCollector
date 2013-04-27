//
//  settingsController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 21/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "settingsController.h"
#import "MyJson.h"

#define kjsonURL @"http://www.chitwan-abroad.org/cloud9/events.php"
//#define kjsonURL @"http://itunes.apple.com/search?term=neil%20north&entity=software&attribute=softwareDeveloper&country=us"

@interface settingsController ()

@end

@implementation settingsController {
    NSMutableArray *jsonResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
//    [super viewDidLoad];
//    [self processJson];
//    NSDictionary *eventCountDict = [jsonResults objectAtIndex:1];
//    NSString    *day = [eventCountDict objectForKey:@"day"];
//    NSString    *date = [eventCountDict objectForKey:@"date"];
//    NSString    *count = [eventCountDict objectForKey:@"count"];
//    NSMutableString *dayDate = [NSMutableString stringWithFormat:@"%@, %@",day,date];
//
//   
    self.testLabel.text = @"hello";
}

- (void)processJson {
    MyJson * json = [[MyJson alloc] init];
    jsonResults = [json toArray:kjsonURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) loadThread(){
//    dispatch_async(kBgQueue, ^{
//        
//        [self fetchedData:data];
//        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
//        [self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>]
//    });
//}

@end
