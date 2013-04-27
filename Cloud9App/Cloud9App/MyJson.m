//
//  MyObject.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 22/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "MyJson.h"

@implementation MyJson ;


-(void) process {
    
    NSData* data = [NSData dataWithContentsOfURL: jsonURL];
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
    
    //NSLog(@"json url inside json.m: %@", jsonUrlString);
    jsonURL = [NSURL URLWithString: jsonUrlString];
    [self process];

    return jsonResults;
}


@end
