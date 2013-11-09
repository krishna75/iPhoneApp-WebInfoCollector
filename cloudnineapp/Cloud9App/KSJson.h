//
//  MyObject.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 22/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KSJson : NSObject {
    NSMutableArray *jsonResults;
    NSURL *jsonURL;
}
//- (id)initWithUrl:(NSString *) jsonUrlString;
- (NSMutableArray *) toArray:(NSString *) jsonUrlString;
- (BOOL) isConnectionAvailable;

@end
