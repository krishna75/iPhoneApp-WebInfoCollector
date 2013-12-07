//
//  KSAllEvents.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 15/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSDailyEvents;

@interface KSAllEvents : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * weekDay;
@property (nonatomic, retain) NSString * count;
@property (nonatomic, retain) NSSet *dailyEvents;
@end

@interface KSAllEvents (CoreDataGeneratedAccessors)

- (void)addDailyEventsObject:(KSDailyEvents *)value;
- (void)removeDailyEventsObject:(KSDailyEvents *)value;
- (void)addDailyEvents:(NSSet *)values;
- (void)removeDailyEvents:(NSSet *)values;

@end
