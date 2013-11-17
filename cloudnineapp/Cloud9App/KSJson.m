//
//  MyObject.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 22/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSJson.h"
#import "SystemConfiguration/SystemConfiguration.h"


@implementation KSJson;
    NSString *jsonHome = @"http://www.cnapp.co.uk/public/";

-(void) process {

    NSError *error;
    NSURLRequest* req=[NSURLRequest requestWithURL: jsonURL];
    NSData* data=[NSURLConnection sendSynchronousRequest: req returningResponse: nil error: &error];
    if (error != NULL) {
        NSLog(@"KSJson process: error %@",[error localizedDescription]);
    }
    
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
}


- (void) fetchedData: (NSData *) responseData {
    NSError* error;
    jsonResults = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
}

-(NSMutableArray *) toArray:(NSString *) jsonUrlString; {
    jsonUrlString =  [NSString stringWithFormat:@"%@%@",jsonHome,jsonUrlString];
//    NSLog(@"KSJson/toArray: url = %@", jsonUrlString);
    jsonURL = [NSURL URLWithString: jsonUrlString];

    if ([self isConnectionAvailable] ){
        [self process];
    }  else {
         jsonResults = [NSMutableArray array];
    }
    return jsonResults;
}

- (BOOL) isConnectionAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "cnapp.co.uk";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
//        NSLog(@"-> connection established!\n");
        return YES;
    }
}

@end
