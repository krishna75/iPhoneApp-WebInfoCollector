//
// Created by Krishna Sapkota on 22/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface KSUsedVoucher : NSObject <NSCoding>

@property (retain, nonatomic) NSString *eventId;
@property (nonatomic) BOOL *used;
@property (nonatomic) BOOL *updatedOnline;

@end