//
//  FirstJsonLoader.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 09/03/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "FirstJsonLoader.h"
#import "KSJson.h"
#import "KSUtilities.h"

#define kjsonVenueURL @"venuesAndEvents.php"
#define kjsonEventURL @"datesAndEvents.php"

static NSMutableArray *venues;
static NSMutableArray *events;
static NSMutableArray  *venueDictArray;

@implementation FirstJsonLoader {
   
}


+ (void) procesJson{
    KSJson * json = [[KSJson alloc] init];
    venues = [json toArray:kjsonVenueURL];
    events = [json toArray:kjsonEventURL];
    NSLog(@"FirstJsonLoader processCoreData: venues: url %@",kjsonVenueURL);
}

+ (void) processVenues{
    venueDictArray = [[NSMutableArray alloc]init];
    NSEnumerator *e = [venues objectEnumerator];
    id object;
    while (object = [e nextObject]) {
        // do something with object
        NSDictionary *jsonDict = object;
       
        NSMutableString *venueId = [jsonDict objectForKey:@"venue_id"];
        NSMutableString *name = [jsonDict objectForKey:@"name"];
        NSMutableString *address = [jsonDict  objectForKey:@"address"];
        NSMutableString *quantity = [jsonDict objectForKey:@"quantity"];
    
        NSMutableString *countDetail = [NSMutableString stringWithFormat:@"%@ Event(s)",quantity];
        
        NSMutableString *logo = [jsonDict objectForKey:@"logo"];
        
        //create a new dictionary of processed values
        NSMutableDictionary *eventDict = [[NSMutableDictionary alloc] init];
        [eventDict setObject:venueId forKey:@"venue_id"];
        [eventDict setObject:name forKey:@"name"];
        [eventDict setObject:address forKey:@"address"];
        [eventDict setObject:countDetail forKey:@"countDetail"];
        [eventDict setObject:logo forKey:@"logo"];
        
        [venueDictArray addObject:eventDict];
        
    }
}



+ (NSMutableArray *) getVenues{
    [FirstJsonLoader processVenues];
    return venueDictArray;
}

+ (NSMutableArray *) getEvents{
  
    return venues;
}

@end
