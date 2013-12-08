//
// Created by Krishna Sapkota on 15/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AppDelegate.h"
#import "KSCoreDataManager.h"
#import "KSEventDetail.h"
#import "KSJson.h"
#import "KSAllEvents.h"
#import "KSDailyEvents.h"
#import "KSAllVenues.h"
#import "KSEventsInVenue.h"
#import "KSAllGenres.h"
#import "KSEventsInGenre.h"
#import "KSVouchersToday.h"
#import "KSInternetManager.h"
#import "KSUsedVoucherManager.h"


#define kUrlEvents @"datesAndEvents.php"
#define kUrlDailyEvents @"eventsOfADate.php?event_date="
#define kUrlEventDetails @"eventDetail.php?event_id="
#define kUrlVenues @"venuesAndEvents.php"
#define kUrlEventsOfVenue @"eventsOfAVenue.php?venue_id="
#define kUrlGenres @"genres.php"
#define kUrlEventsOfGenre @"eventsOfGenre.php?genre_id="
#define kUrlVoucher @"vouchers.php"


static NSArray *events;
static NSArray *venues;
static NSArray *genres;
static NSArray *vouchers;
static BOOL eventsProcessed = NO;
static BOOL venuesProcessed = NO;
static BOOL genresProcessed = NO;
static BOOL vouchersProcessed = NO;
@implementation KSCoreDataManager {

}
+ (void)createEvents {
    NSDate* startTime = [NSDate date];
    if ([[[KSJson alloc] init] isConnectionAvailable] && !eventsProcessed){

        NSMutableArray *results = [[NSMutableArray alloc] init] ;
        // creating the context for the core data
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        for (NSDictionary * eventCountDict in [[[KSJson alloc] init] toArray:kUrlEvents]) {

            // all events
            KSAllEvents *allEvents = [NSEntityDescription insertNewObjectForEntityForName:@"KSAllEvents" inManagedObjectContext:context];
            allEvents.count = [eventCountDict objectForKey:@"quantity"] ;
            allEvents.date = [eventCountDict objectForKey:@"date"] ;
            allEvents.weekDay = [eventCountDict objectForKey:@"day"] ;

            // daily events
            NSMutableArray *dailyEventsArray = [[NSMutableArray alloc] init];
            KSJson * json = [[KSJson alloc] init];
            NSString *urlDailyEvents  = [NSString stringWithFormat:@"%@%@", kUrlDailyEvents, allEvents.date];

            for (NSDictionary *dailyEventsDict in [json toArray:urlDailyEvents]) {
                KSDailyEvents *dailyEvents = [NSEntityDescription insertNewObjectForEntityForName:@"KSDailyEvents" inManagedObjectContext:context];
                dailyEvents.date = [dailyEventsDict objectForKey:@"date"];
                dailyEvents.weekDay = [dailyEventsDict objectForKey:@"day"];

                dailyEvents.eventId = [dailyEventsDict objectForKey:@"id"];
                dailyEvents.eventName = [dailyEventsDict objectForKey:@"title"];
                dailyEvents.eventDescription = [dailyEventsDict objectForKey:@"description"];

                dailyEvents.venueId = [dailyEventsDict objectForKey:@"venue_id"];
                dailyEvents.venueName = [dailyEventsDict objectForKey:@"venue"];
                dailyEvents.venueLogo = [dailyEventsDict objectForKey:@"venue_logo"] ;

                // relations
                dailyEvents.allEvents = allEvents;
                [dailyEventsArray addObject:dailyEvents];

                // event detail
                NSString * eventDetailUrl = [NSString stringWithFormat:@"%@%@", kUrlEventDetails, dailyEvents.eventId];
                NSDictionary *eventDetailDict = [[json toArray:eventDetailUrl] objectAtIndex:0];

                KSEventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"KSEventDetail" inManagedObjectContext:context];
                eventDetail.date = [eventDetailDict objectForKey:@"date"];
                eventDetail.eventDescription = [eventDetailDict objectForKey:@"description"];
                eventDetail.eventId= [eventDetailDict objectForKey:@"id"];
                eventDetail.eventName = [eventDetailDict objectForKey:@"title"];
                eventDetail.photo = [eventDetailDict objectForKey:@"photo"];
                eventDetail.logo = [eventDetailDict objectForKey:@"logo"];

                eventDetail.venueId = [eventDetailDict objectForKey:@"venue_id"];
                eventDetail.venueName = [eventDetailDict objectForKey:@"venue"];

                eventDetail.voucherDescription= [eventDetailDict objectForKey:@"voucher_description"];
                eventDetail.voucherPhoto= [eventDetailDict objectForKey:@"voucher_photo"];

                // relations
                eventDetail.dailyEvents = dailyEvents;
                dailyEvents.eventDetail = eventDetail;
            }

            // relation
            allEvents.dailyEvents= [NSSet setWithArray:dailyEventsArray] ;

            //saving data
            NSError *error = nil;
                if (![context save:&error]) {
                    ALog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            [results addObject:allEvents];
        }

        ALog(@" events size = %d", [results count] );
       events = results;

       int timeTaken = (int) [[NSDate date] timeIntervalSinceDate:startTime];
       ALog(@" time taken to process (download) all the events = %d seconds",timeTaken) ;
       eventsProcessed = YES;
    }
}

+ (void)createVenues {
    NSDate* startTime = [NSDate date];
    if ([[[KSJson alloc] init] isConnectionAvailable] && !venuesProcessed){

        NSMutableArray *results = [[NSMutableArray alloc] init] ;

        //get the context
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        for (NSDictionary *jsonDict in [[[KSJson alloc] init] toArray:kUrlVenues]) {

            //all venues
            KSAllVenues *allVenues = [NSEntityDescription insertNewObjectForEntityForName:@"KSAllVenues" inManagedObjectContext:context];
            allVenues.date = [jsonDict objectForKey:@"date"];
            allVenues.venueId = [jsonDict objectForKey:@"venue_id"];
            allVenues.venueName = [jsonDict objectForKey:@"name"];
            allVenues.venueAddress = [jsonDict  objectForKey:@"address"];
            allVenues.venueLogo = [jsonDict objectForKey:@"logo"];
            NSMutableString *quantity = [jsonDict objectForKey:@"quantity"];
            allVenues.eventCountDetail = [NSMutableString stringWithFormat:@"%@ Event(s)",quantity];

            // events in a venue
            NSMutableArray *eventsInVenueArray = [[NSMutableArray alloc] init];
            KSJson * json = [[KSJson alloc] init];
            NSString *jsonURL  = [NSString stringWithFormat:@"%@%@", kUrlEventsOfVenue, allVenues.venueId];

            for (NSDictionary *eventsInVenueDict in [json toArray:jsonURL]) {
                KSEventsInVenue *eventsInVenue = [NSEntityDescription insertNewObjectForEntityForName:@"KSEventsInVenue" inManagedObjectContext:context];
                eventsInVenue.eventId = [eventsInVenueDict objectForKey:@"event_id"];
                eventsInVenue.date = [eventsInVenueDict objectForKey:@"date"];
                eventsInVenue.eventName = [eventsInVenueDict objectForKey:@"event_title"];

                // relations
                eventsInVenue.allVenues = allVenues;
                [eventsInVenueArray addObject:eventsInVenue];

                // event detail
                NSString * eventDetailUrl = [NSString stringWithFormat:@"%@%@", kUrlEventDetails,eventsInVenue.eventId];
                NSDictionary *eventDetailDict = [[json toArray:eventDetailUrl] objectAtIndex:0];

                KSEventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"KSEventDetail" inManagedObjectContext:context];
                eventDetail.date = [eventDetailDict objectForKey:@"date"];
                eventDetail.eventDescription = [eventDetailDict objectForKey:@"description"];
                eventDetail.eventId= [eventDetailDict objectForKey:@"id"];
                eventDetail.eventName = [eventDetailDict objectForKey:@"title"];
                eventDetail.photo = [eventDetailDict objectForKey:@"photo"];
                eventDetail.logo = [eventDetailDict objectForKey:@"logo"];

                eventDetail.venueId = [eventDetailDict objectForKey:@"venue_id"];
                eventDetail.venueName = [eventDetailDict objectForKey:@"venue"];

                eventDetail.voucherDescription= [eventDetailDict objectForKey:@"voucher_description"];
                eventDetail.voucherPhoto= [eventDetailDict objectForKey:@"voucher_photo"];

                // relations
                eventDetail.eventsInVenue = eventsInVenue;
                eventsInVenue.eventDetails = eventDetail;
            }

            // relation
            allVenues.eventsInVenue = [NSSet setWithArray:eventsInVenueArray] ;

            // saving data
            NSError *error = nil;
                if (![context save:&error]) {
                    ALog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            [results addObject:allVenues];
        }
        ALog(@"KSCoreDataManager/createVenues: venues size = %d", [results count]) ;
        venues = results;
        venuesProcessed = YES;

        int timeTaken = (int) [[NSDate date] timeIntervalSinceDate:startTime];
        ALog(@" time taken to process (download) all the venues = %d seconds",timeTaken) ;
    }
}

+ (void)createGenres {
    NSDate* startTime = [NSDate date];
    if ([[[KSJson alloc] init] isConnectionAvailable] && !genresProcessed){

        NSMutableArray *results = [[NSMutableArray alloc] init] ;

        // get the context
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        for (NSDictionary *jsonDict in [[[KSJson alloc] init] toArray:kUrlGenres]) {

        // all genres
        KSAllGenres *allGenres = [NSEntityDescription insertNewObjectForEntityForName:@"KSAllGenres" inManagedObjectContext:context];
        allGenres.genreId = [jsonDict objectForKey:@"id"];
        allGenres.genreName= [jsonDict objectForKey:@"genre"];
        allGenres.genreDescription = [jsonDict objectForKey:@"description"];
        allGenres.genrePhoto = [jsonDict  objectForKey:@"photo"];

        // events in a genre
        NSMutableArray *eventsInGenreArray = [[NSMutableArray alloc] init];
        KSJson * json = [[KSJson alloc] init];

            for (NSDictionary *eventsInGenreDict in [json toArray:[NSString stringWithFormat:@"%@%@", kUrlEventsOfGenre, allGenres.genreId]]) {
            KSEventsInGenre *eventsInGenre = [NSEntityDescription insertNewObjectForEntityForName:@"KSEventsInGenre" inManagedObjectContext:context];
            eventsInGenre.eventId = [eventsInGenreDict objectForKey:@"event_id"];
            eventsInGenre.date = [eventsInGenreDict objectForKey:@"date"];
            eventsInGenre.eventName = [eventsInGenreDict objectForKey:@"event_title"];

            //relationship
            eventsInGenre.allGenres = allGenres;
            [eventsInGenreArray addObject:eventsInGenre];

            // event detail
            NSDictionary *eventDetailDict = [[json toArray:[NSString stringWithFormat:@"%@%@", kUrlEventDetails, eventsInGenre.eventId]] objectAtIndex:0];

            KSEventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"KSEventDetail" inManagedObjectContext:context];
            eventDetail.date = [eventDetailDict objectForKey:@"date"];
            eventDetail.eventDescription = [eventDetailDict objectForKey:@"description"];
            eventDetail.eventId= [eventDetailDict objectForKey:@"id"];
            eventDetail.eventName = [eventDetailDict objectForKey:@"title"];
            eventDetail.photo = [eventDetailDict objectForKey:@"photo"];
            eventDetail.logo = [eventDetailDict objectForKey:@"logo"];

            eventDetail.venueId = [eventDetailDict objectForKey:@"venue_id"];
            eventDetail.venueName = [eventDetailDict objectForKey:@"venue"];
            eventDetail.voucherDescription= [eventDetailDict objectForKey:@"voucher_description"];
            eventDetail.voucherPhoto= [eventDetailDict objectForKey:@"voucher_photo"];

            // relationship
            eventDetail.eventsInGenre = eventsInGenre;
            eventsInGenre.eventDetails = eventDetail;
        }

            //relationship
            allGenres.eventsInGenre = [NSSet setWithArray:eventsInGenreArray] ;

            //saving data
            NSError *error = nil;
                if (![context save:&error]) {
                    ALog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            [results addObject:allGenres];
        }
        ALog(@" genres size = %d", [results count]) ;
        genres = results;
    genresProcessed = YES;
    }
    int timeTaken = (int) [[NSDate date] timeIntervalSinceDate:startTime];
    ALog(@" time taken to process (download) all the Genres = %d seconds",timeTaken) ;
}

+ (void)createVouchers {
    NSDate* startTime = [NSDate date];
    if ([[[KSJson alloc] init] isConnectionAvailable] && !vouchersProcessed){

        NSMutableArray *results = [[NSMutableArray alloc] init] ;

        // get the context
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        for (NSDictionary *jsonDict in [[[KSJson alloc] init] toArray:kUrlVoucher]) {

            // vouchers today
            KSVouchersToday *vouchersToday = [NSEntityDescription insertNewObjectForEntityForName:@"KSVouchersToday" inManagedObjectContext:context];
            vouchersToday.venueId = [jsonDict objectForKey:@"venue_id"];
            vouchersToday.venueName= [jsonDict objectForKey:@"name"];
            vouchersToday.venueAddress = [jsonDict objectForKey:@"address"];
            vouchersToday.venueLogo= [jsonDict  objectForKey:@"logo"];
            vouchersToday.eventId= [jsonDict  objectForKey:@"event_id"];
            vouchersToday.eventName= [jsonDict  objectForKey:@"event_title"];
            vouchersToday.voucherDescription= [jsonDict  objectForKey:@"voucher_description"];
            vouchersToday.voucherPhoto= [jsonDict  objectForKey:@"voucher_photo"];

            // event details
            KSEventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"KSEventDetail" inManagedObjectContext:context];
            eventDetail.venueId = vouchersToday.venueId;
            eventDetail.venueName = vouchersToday.venueName;
            eventDetail.eventId = vouchersToday.eventId;
            eventDetail.eventName = vouchersToday.eventName;
            eventDetail.voucherDescription = vouchersToday.voucherDescription ;
            eventDetail.voucherPhoto = vouchersToday.voucherPhoto;
            eventDetail.logo = vouchersToday.venueLogo;

            // adding today's date  to the event details
            NSDate *today = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"YYYY-MM-dd"];
            NSString *todayString = [dateFormat stringFromDate:today];
            eventDetail.date = todayString;

            // relations
            eventDetail.vouchersToday = vouchersToday;
            vouchersToday.eventDetails = eventDetail;

            //saving data
            NSError *error = nil;
                if (![context save:&error]) {
                    ALog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            [results addObject:vouchersToday];
        }
        ALog(@" genres size = %d", [results count]) ;
        vouchers = results;
        vouchersProcessed = YES;
        int timeTaken = (int) [[NSDate date] timeIntervalSinceDate:startTime];
        ALog(@" time taken to process (download) all the vouchers = %d seconds",timeTaken) ;
    }
}

+ (void)createAll {
    if ([[[KSJson alloc] init] isConnectionAvailable]){
        NSDate* startTime = [NSDate date];

        [self deleteCoreData];

        // creating core data
        [self createEvents];
        [self createVenues];
        [self createGenres];
        [self createVouchers];

        // processing other initial stuff
        [KSInternetManager downloadVoucherImages];
        [[[KSUsedVoucherManager alloc] init] updateOnline];

        int timeTaken = (int) [[NSDate date] timeIntervalSinceDate:startTime];
        ALog(@" time taken to process (download) all the data = %d seconds",timeTaken) ;
    }
}

+ (NSArray *)loadEvents {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KSAllEvents" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray *)loadVenues {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KSAllVenues" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray *)loadGenres {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KSAllGenres" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray *)loadVouchers {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KSVouchersToday" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray *)getEvents {
    if ([[[KSJson alloc] init] isConnectionAvailable]){
       return events ;
    } else {
        return [self loadEvents];
    }
}

+ (NSArray *) getVenues {
    if ([[[KSJson alloc] init] isConnectionAvailable]){
        return venues ;
    } else {
        return [self loadVenues];
    }
}

+ (NSArray *)getGenres {
    if ([[[KSJson alloc] init] isConnectionAvailable]){
        return genres ;
    } else {
        return [self loadGenres];
    }
}

+ (NSArray *)getVouchers {
    if ([[[KSJson alloc] init] isConnectionAvailable]){
        return vouchers ;
    } else {
        return [self loadVouchers];
    }
}

+(void) deleteCoreData {
//    ALog(@" deleting object: %@ ",entityDescription);
    ALog(@"deleting all the coredata ");
    AppDelegate *appDelegate = [[AppDelegate alloc]init];
    NSArray *stores = [appDelegate.persistentStoreCoordinator persistentStores];

    for(NSPersistentStore *store in stores) {
        [appDelegate.persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }

}


@end