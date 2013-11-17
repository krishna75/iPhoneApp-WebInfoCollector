//
// Created by Krishna Sapkota on 15/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@interface KSCoreDataManager : NSObject


+ (void) createEvents;
+ (void) createVenues;
+ (void) createGenres;
+ (void) createVouchers;
+ (void) createAll;

+ (NSArray *) loadEvents;
+ (NSArray *) loadVenues;
+ (NSArray *) loadGenres;
+ (NSArray *) loadVouchers;

+ (NSArray *) getEvents;
+ (NSArray *) getVenues;
+ (NSArray *) getGenres;
+ (NSArray *) getVouchers;

+ (void) deleteCoreData;

@end