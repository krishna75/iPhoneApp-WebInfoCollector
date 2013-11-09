//
//  JsonArray.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Json : NSObject {
    //NSMutableArray *jsonResults;
     //NSString *trackName;
}

@property (nonatomic,retain) NSString *trackName;
-(NSMutableArray *) getresults;
-(NSString *) getTrackName;

@end
