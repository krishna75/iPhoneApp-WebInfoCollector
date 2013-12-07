//
//  KSVoucher.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 14/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSEventDetail;

@interface KSVoucher : NSManagedObject

@property (nonatomic, retain) NSDate * voucherDate;
@property (nonatomic, retain) NSString * voucherDescription;
@property (nonatomic, retain) NSString * voucherPhoto;
@property (nonatomic, retain) KSEventDetail *eventDetails;

@end
