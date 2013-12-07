//
//  KSVouchersToday.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 14/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSEventDetail;

@interface KSVouchersToday : NSManagedObject

@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * venueAddress;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * venueLogo;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * voucherDescription;
@property (nonatomic, retain) NSString * voucherPhoto;
@property (nonatomic, retain) KSEventDetail *eventDetails;

@end
