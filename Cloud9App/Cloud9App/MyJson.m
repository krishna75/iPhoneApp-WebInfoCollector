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

-(void) process {

    NSError *error;
    NSURLRequest* req=[NSURLRequest requestWithURL: jsonURL];
    NSData* data=[NSURLConnection sendSynchronousRequest: req returningResponse: nil error: &error];
    NSLog(@"error %@",[error localizedDescription]);
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
}


- (void) fetchedData: (NSData *) responseData {
    NSError* error;
    jsonResults = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
}

-(NSMutableArray *) toArray:(NSString *) jsonUrlString; {
    jsonURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",jsonHome,jsonUrlString]];
    [self process];
    return jsonResults;
}


@end
