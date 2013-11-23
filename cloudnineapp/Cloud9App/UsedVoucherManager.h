//
// Created by Krishna Sapkota on 22/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class UsedVoucher;


@interface UsedVoucherManager : NSObject

@property (retain, nonatomic) NSDictionary *usedVoucherDict;



- (void) updateOnline;
- (void) addUsedVoucher:(UsedVoucher *)usedVoucher;
- (void) save;

@end