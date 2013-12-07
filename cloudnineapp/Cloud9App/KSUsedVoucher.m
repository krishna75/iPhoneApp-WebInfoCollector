//
// Created by Krishna Sapkota on 22/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "KSUsedVoucher.h"


@implementation KSUsedVoucher {

}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _eventId = [decoder decodeObjectForKey:@"eventId"];
        _used = [decoder  decodeBoolForKey:@"used"];
        _updatedOnline = [decoder decodeBoolForKey:@"updatedOnline"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_eventId forKey:@"eventId"];
    [encoder encodeBool:_used forKey:@"used"];
    [encoder encodeBool:_updatedOnline forKey:@"updatedOnline"];
}


@end