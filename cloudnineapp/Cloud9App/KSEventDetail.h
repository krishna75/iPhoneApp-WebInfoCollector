//
//  KSEventDetail.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 08/12/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSDailyEvents, KSEventsInGenre, KSEventsInVenue, KSVoucher, KSVouchersToday;

@interface KSEventDetail : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * voucherDescription;
@property (nonatomic, retain) NSString * voucherPhoto;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) KSDailyEvents *dailyEvents;
@property (nonatomic, retain) KSEventsInGenre *eventsInGenre;
@property (nonatomic, retain) KSEventsInVenue *eventsInVenue;
@property (nonatomic, retain) KSVoucher *voucher;
@property (nonatomic, retain) KSVouchersToday *vouchersToday;

@end
