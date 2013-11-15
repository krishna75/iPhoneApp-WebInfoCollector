//
// Created by Krishna Sapkota on 15/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AppDelegate.h"
#import "KSCoreDataManager.h"
#import "EventDetail.h"
#import "KSJson.h"
#import "AllEvents.h"
#import "DailyEvents.h"
#import "AllVenues.h"
#import "EventsInVenue.h"
#import "AllGenres.h"
#import "EventsInGenre.h"
#import "VouchersToday.h"


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
static BOOL allProcessed = NO;
@implementation KSCoreDataManager {

}
+ (void)createEvents {
    if ([[[KSJson alloc] init] isConnectionAvailable] && !allProcessed){

        NSMutableArray *results = [[NSMutableArray alloc] init] ;

        // creating the context for the core data
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        for (NSDictionary * eventCountDict in [[[KSJson alloc] init] toArray:kUrlEvents]) {

            // all events
            AllEvents *allEvents = [NSEntityDescription insertNewObjectForEntityForName:@"AllEvents" inManagedObjectContext:context];
            allEvents.count = [eventCountDict objectForKey:@"quantity"] ;
            allEvents.date = [eventCountDict objectForKey:@"date"] ;
            allEvents.weekDay = [eventCountDict objectForKey:@"day"] ;

            // daily events
            NSMutableArray *dailyEventsArray = [[NSMutableArray alloc] init];
            KSJson * json = [[KSJson alloc] init];
            NSString *urlDailyEvents  = [NSString stringWithFormat:@"%@%@", kUrlDailyEvents, allEvents.date];

            for (NSDictionary *dailyEventsDict in [json toArray:urlDailyEvents]) {
                DailyEvents *dailyEvents = [NSEntityDescription insertNewObjectForEntityForName:@"DailyEvents" inManagedObjectContext:context];
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

                EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:context];
                eventDetail.date = [eventDetailDict objectForKey:@"date"];
                eventDetail.eventDescription = [eventDetailDict objectForKey:@"description"];
                eventDetail.eventId= [eventDetailDict objectForKey:@"id"];
                eventDetail.eventName = [eventDetailDict objectForKey:@"title"];
                eventDetail.photo = [eventDetailDict objectForKey:@"photo"];

                eventDetail.venueId = [eventDetailDict objectForKey:@"venue_id"];
                eventDetail.venueName = [eventDetailDict objectForKey:@"venue"];

                eventDetail.voucherDescription= [eventDetailDict objectForKey:@"voucher_description"];
                eventDetail.voucherPhoto= [eventDetailDict objectForKey:@"voucher_photo"];

                // relations
                eventDetail.dailyEvents = dailyEvents;
                dailyEvents.eventDetail = eventDetail;
            }
            ALog(@"KSCoreDataManager/createEvents: dailyEventsArray.size = %d", [dailyEventsArray count]) ;

            // relation
            allEvents.dailyEvents= [NSSet setWithArray:dailyEventsArray] ;

            //checking if the  data already exists
            BOOL saveOk = YES;
            NSArray *lastSaved = [self loadEvents];
            for (AllEvents * lastEvent in lastSaved ) {
                if ([lastEvent.date isEqualToString:allEvents.date]){
                    saveOk = NO;
                }
            }

            //saving data
            NSError *error = nil;
            if (saveOk) {
                if (![context save:&error]) {
                    ALog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            }
            [results addObject:allEvents];
        }

       events = results;
    }
}

+ (void)createVenues {
    if ([[[KSJson alloc] init] isConnectionAvailable] && !allProcessed){

        NSMutableArray *results = [[NSMutableArray alloc] init] ;

        //get the context
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        for (NSDictionary *jsonDict in [[[KSJson alloc] init] toArray:kUrlVenues]) {

            //all venues
            AllVenues *allVenues = [NSEntityDescription insertNewObjectForEntityForName:@"AllVenues" inManagedObjectContext:context];
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
                EventsInVenue *eventsInVenue = [NSEntityDescription insertNewObjectForEntityForName:@"EventsInVenue" inManagedObjectContext:context];
                eventsInVenue.eventId = [eventsInVenueDict objectForKey:@"event_id"];
                eventsInVenue.date = [eventsInVenueDict objectForKey:@"date"];
                eventsInVenue.eventName = [eventsInVenueDict objectForKey:@"event_title"];

                // relations
                eventsInVenue.allVenues = allVenues;
                [eventsInVenueArray addObject:eventsInVenue];

                // event detail
                NSString * eventDetailUrl = [NSString stringWithFormat:@"%@%@", kUrlEventDetails,eventsInVenue.eventId];
                NSDictionary *eventDetailDict = [[json toArray:eventDetailUrl] objectAtIndex:0];

                EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:context];
                eventDetail.date = [eventDetailDict objectForKey:@"date"];
                eventDetail.eventDescription = [eventDetailDict objectForKey:@"description"];
                eventDetail.eventId= [eventDetailDict objectForKey:@"id"];
                eventDetail.eventName = [eventDetailDict objectForKey:@"title"];
                eventDetail.photo = [eventDetailDict objectForKey:@"photo"];

                eventDetail.venueId = [eventDetailDict objectForKey:@"venue_id"];
                eventDetail.venueName = [eventDetailDict objectForKey:@"venue"];

                eventDetail.voucherDescription= [eventDetailDict objectForKey:@"voucher_description"];
                eventDetail.voucherPhoto= [eventDetailDict objectForKey:@"voucher_photo"];

                ALog(@"AllVenuesController/createCoreData: eventName=%@",eventDetail.eventName);

                // relations
                eventDetail.eventsInVenue = eventsInVenue;
                eventsInVenue.eventDetails = eventDetail;
            }
            ALog(@"KSCoreDataManager/createVenues: eventsInVenueArray.size = %d", [eventsInVenueArray count]) ;

            // relation
            allVenues.eventsInVenue = [NSSet setWithArray:eventsInVenueArray] ;

            //checking if the  data already exists
            BOOL saveOk = YES;
            NSArray *lastSaved = [self loadVenues];
            for (AllVenues * lastVenue in lastSaved ) {
                if ([lastVenue.eventId isEqualToString:allVenues.eventId]){
                    saveOk = NO;
                }
            }

            // saving data
            NSError *error = nil;
            if (saveOk) {
                if (![context save:&error]) {
                    ALog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            }
            [results addObject:allVenues];
        }
        venues = results;
    }
}

+ (void)createGenres {
    if ([[[KSJson alloc] init] isConnectionAvailable] && !allProcessed){

        NSMutableArray *results = [[NSMutableArray alloc] init] ;

        // get the context
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        for (NSDictionary *jsonDict in [[[KSJson alloc] init] toArray:kUrlGenres]) {

        // all genres
        AllGenres *allGenres = [NSEntityDescription insertNewObjectForEntityForName:@"AllGenres" inManagedObjectContext:context];
        allGenres.genreId = [jsonDict objectForKey:@"id"];
        allGenres.genreName= [jsonDict objectForKey:@"genre"];
        allGenres.genreDescription = [jsonDict objectForKey:@"description"];
        allGenres.genrePhoto = [jsonDict  objectForKey:@"photo"];

        // events in a genre
        NSMutableArray *eventsInGenreArray = [[NSMutableArray alloc] init];
        KSJson * json = [[KSJson alloc] init];

            for (NSDictionary *eventsInGenreDict in [json toArray:[NSString stringWithFormat:@"%@%@", kUrlEventsOfGenre, allGenres.genreId]]) {
            EventsInGenre *eventsInGenre = [NSEntityDescription insertNewObjectForEntityForName:@"EventsInGenre" inManagedObjectContext:context];
            eventsInGenre.eventId = [eventsInGenreDict objectForKey:@"event_id"];
            eventsInGenre.date = [eventsInGenreDict objectForKey:@"date"];
            eventsInGenre.eventName = [eventsInGenreDict objectForKey:@"event_title"];

            //relationship
            eventsInGenre.allGenres = allGenres;
            [eventsInGenreArray addObject:eventsInGenre];

            // event detail
            NSDictionary *eventDetailDict = [[json toArray:[NSString stringWithFormat:@"%@%@", kUrlEventDetails, eventsInGenre.eventId]] objectAtIndex:0];

            EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:context];
            eventDetail.date = [eventDetailDict objectForKey:@"date"];
            eventDetail.eventDescription = [eventDetailDict objectForKey:@"description"];
            eventDetail.eventId= [eventDetailDict objectForKey:@"id"];
            eventDetail.eventName = [eventDetailDict objectForKey:@"title"];
            eventDetail.photo = [eventDetailDict objectForKey:@"photo"];
            eventDetail.venueId = [eventDetailDict objectForKey:@"venue_id"];
            eventDetail.venueName = [eventDetailDict objectForKey:@"venue"];
            eventDetail.voucherDescription= [eventDetailDict objectForKey:@"voucher_description"];
            eventDetail.voucherPhoto= [eventDetailDict objectForKey:@"voucher_photo"];

            // relationship
            eventDetail.eventsInGenre = eventsInGenre;
            eventsInGenre.eventDetails = eventDetail;
        }
        ALog(@"KSCoreDataManager/createGenres: eventsInGenreArray.size = %d", [eventsInGenreArray count]) ;

        //relationship
        allGenres.eventsInGenre = [NSSet setWithArray:eventsInGenreArray] ;

        //checking if the  data already exists
        BOOL saveOk = YES;
        NSArray *lastSaved = [self loadGenres];
        for (AllGenres *lastGenre in lastSaved ) {
            if ([lastGenre.genreId isEqualToString:allGenres.genreId]){
                saveOk = NO;
            }
        }

        //saving data
        NSError *error = nil;
        if (saveOk) {
            if (![context save:&error]) {
                ALog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        [results addObject:allGenres];
    }
    genres = results;
    }
}

+ (void)createVouchers {
    if ([[[KSJson alloc] init] isConnectionAvailable] && !allProcessed){

        NSMutableArray *results = [[NSMutableArray alloc] init] ;

        // get the context
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];

        for (NSDictionary *jsonDict in [[[KSJson alloc] init] toArray:kUrlVoucher]) {

            // vouchers today
            VouchersToday *vouchersToday = [NSEntityDescription insertNewObjectForEntityForName:@"VouchersToday" inManagedObjectContext:context];
            vouchersToday.venueId = [jsonDict objectForKey:@"venue_id"];
            vouchersToday.venueName= [jsonDict objectForKey:@"name"];
            vouchersToday.venueAddress = [jsonDict objectForKey:@"address"];
            vouchersToday.venueLogo= [jsonDict  objectForKey:@"logo"];
            vouchersToday.eventId= [jsonDict  objectForKey:@"event_id"];
            vouchersToday.eventName= [jsonDict  objectForKey:@"event_title"];
            vouchersToday.voucherDescription= [jsonDict  objectForKey:@"voucher_description"];
            vouchersToday.voucherPhoto= [jsonDict  objectForKey:@"voucher_photo"];

            // event details
            EventDetail *eventDetail = [NSEntityDescription insertNewObjectForEntityForName:@"EventDetail" inManagedObjectContext:context];
            eventDetail.venueId = vouchersToday.venueId;
            eventDetail.venueName = vouchersToday.venueName;
            eventDetail.eventId = vouchersToday.eventId;
            eventDetail.eventName = vouchersToday.eventName;
            eventDetail.voucherDescription = vouchersToday.voucherDescription ;
            eventDetail.voucherPhoto = vouchersToday.voucherPhoto;

            // adding today's date  to the event details
            NSDate *today = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"YYYY-MM-dd"];
            NSString *todayString = [dateFormat stringFromDate:today];
            eventDetail.date = todayString;

            // relations
            eventDetail.vouchersToday = vouchersToday;
            vouchersToday.eventDetails = eventDetail;

            // checking if the  data already exists
            BOOL saveOk = YES;
            NSArray *lastSaved = [self loadVouchers];
            for (VouchersToday *lastVoucher in lastSaved ) {
                if ([lastVoucher.eventId isEqualToString:vouchersToday.eventId]){
                    saveOk = NO;
                }
            }

            //saving data
            NSError *error = nil;
            if (saveOk) {
                if (![context save:&error]) {
                    ALog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            }
            [results addObject:vouchersToday];
        }
        vouchers = results;
    }
}

+ (void)createAll {
    [self createEvents];
    [self createVenues];
    [self createGenres];
    [self createVouchers];
    allProcessed = YES;
}

+ (NSArray *)loadEvents {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllEvents" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray *)loadVenues {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllVenues" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray *)loadGenres {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AllGenres" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

+ (NSArray *)loadVouchers {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VouchersToday" inManagedObjectContext:context];
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


@end