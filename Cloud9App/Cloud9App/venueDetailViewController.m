//
//  venueDetailViewController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 19/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#define kBgQueue  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#import "venueDetailViewController.h"

@interface venueDetailViewController ()

@end



@implementation venueDetailViewController {
    
    NSString *jsonURL;
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //_venueId = @"hello mike testing";
    //self.testLabel.text = _venueId;
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_sky_small.png"]];
    
    NSString* myString = @"http://www.chitwan-abroad.org/cloud9/venueDetail.php?venue_id=";
    myString = [myString stringByAppendingString:_venueId];;
    jsonURL =[NSURL URLWithString: myString];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: jsonURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void) fetchedData: (NSData *) responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    jsonResults NSDate *now = [[NSDate alloc] init];= json;
    NSDictionary* appsDict = [jsonResults objectAtIndex:0];
    self.testLabel.text = [appsDict objectForKey:@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
