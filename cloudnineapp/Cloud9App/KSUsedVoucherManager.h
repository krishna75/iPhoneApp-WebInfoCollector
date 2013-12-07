//
// Created by Krishna Sapkota on 22/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class KSUsedVoucher;


@interface KSUsedVoucherManager : NSObject

@property (retain, nonatomic) NSMutableDictionary *usedVoucherDict;



- (void) updateOnline;
- (void) addUsedVoucher:(KSUsedVoucher *)usedVoucher;
- (void) save;
- (BOOL *) isUsed:(NSString *)eventId ;
-(BOOL)writeToPlistFile:(NSString*)filename forDict:(NSDictionary *) dict;
- (NSDictionary*)readFromPlistFile:(NSString*)filename;

@end