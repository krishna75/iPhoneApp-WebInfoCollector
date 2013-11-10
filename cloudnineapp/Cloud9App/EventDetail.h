//
//  EventDetail.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 10/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DailyEvents, Voucher;

@interface EventDetail : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * voucherDescription;
@property (nonatomic, retain) NSString * voucherPhoto;
@property (nonatomic, retain) DailyEvents *dailyEvents;
@property (nonatomic, retain) Voucher *voucher;
@property (nonatomic, retain) NSManagedObject *eventsInVenue;

@end
