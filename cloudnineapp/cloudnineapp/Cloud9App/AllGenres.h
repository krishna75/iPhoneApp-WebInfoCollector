//
//  AllGenres.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 14/11/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventsInGenre;

@interface AllGenres : NSManagedObject

@property (nonatomic, retain) NSString * genreDescription;
@property (nonatomic, retain) NSString * genreId;
@property (nonatomic, retain) NSString * genreName;
@property (nonatomic, retain) NSString * genrePhoto;
@property (nonatomic, retain) NSSet *eventsInGenre;
@end

@interface AllGenres (CoreDataGeneratedAccessors)

- (void)addEventsInGenreObject:(EventsInGenre *)value;
- (void)removeEventsInGenreObject:(EventsInGenre *)value;
- (void)addEventsInGenre:(NSSet *)values;
- (void)removeEventsInGenre:(NSSet *)values;

@end
