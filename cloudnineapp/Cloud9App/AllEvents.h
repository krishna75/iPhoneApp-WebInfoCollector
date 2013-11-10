//
//  AllEvents.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 09/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DailyEvents;

@interface AllEvents : NSManagedObject

@property (nonatomic, retain) NSNumber * dateDay;
@property (nonatomic, retain) NSString * eventCountDetails;
@property (nonatomic, retain) NSNumber * numNewEvents;
@property (nonatomic, retain) NSString * shortMonth;
@property (nonatomic, retain) NSString * weekDay;
@property (nonatomic, retain) NSString * eventDate;
@property (nonatomic, retain) NSSet *dailyEvents;
@end

@interface AllEvents (CoreDataGeneratedAccessors)

- (void)addDailyEventsObject:(DailyEvents *)value;
- (void)removeDailyEventsObject:(DailyEvents *)value;
- (void)addDailyEvents:(NSSet *)values;
- (void)removeDailyEvents:(NSSet *)values;

@end
