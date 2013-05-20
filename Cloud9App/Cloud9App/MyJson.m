//
//  MyObject.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 22/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "MyJson.h"

@implementation MyJson ;
    NSString *jsonHome = @"http://www.cnapp.co.uk/public/";
//    NSString *jsonHome = @"http://www.chitwan-abroad.org/cloud9/";

-(void) process {

    NSError *error;
    NSURLRequest* req=[NSURLRequest requestWithURL: jsonURL];
    NSData* data=[NSURLConnection sendSynchronousRequest: req returningResponse: nil error: &error];
    NSLog(@"error %@",[error localizedDescription]);
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    
    
//    NSURL *url = [NSURL URLWithString:@"http://www.chitwan-abroad.org/cloud9/events.php"];
//    NSData* data = [NSData dataWithContentsOfURL: url];
//    NSError* error;
//    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
//   jsonResults = [json objectForKey:@"results"];
    
//    NSLog(@"size of the results: %i", [jsonResults count]);

   
}


- (void) fetchedData: (NSData *) responseData {
    NSError* error;
    jsonResults = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    //jsonResults = [json objectForKey:@"results"];
    
}

-(NSMutableArray *) toArray:(NSString *) jsonUrlString; {
//    NSString *completeJsonUrl = [NSString stringWithFormat:@"%@%@",jsonHome,jsonUrlString];
    
    //NSLog(@"json url inside json.m: %@", jsonUrlString);
    jsonURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",jsonHome,jsonUrlString]];
    [self process];

    return jsonResults;
}


@end
