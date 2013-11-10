//
//  Voucher.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 10/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventDetail;

@interface Voucher : NSManagedObject

@property (nonatomic, retain) NSDate * voucherDate;
@property (nonatomic, retain) NSString * voucherDescription;
@property (nonatomic, retain) NSString * voucherPhoto;
@property (nonatomic, retain) EventDetail *eventDeail;

@end
