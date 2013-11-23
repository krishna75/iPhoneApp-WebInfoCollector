//
// Created by Krishna Sapkota on 22/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UsedVoucherManager.h"
#import "UsedVoucher.h"
#import "KSJson.h"

@implementation UsedVoucherManager {

}

- (id) init {
    self = [super init];
    [self readDict];
    return self;
}

- (void)updateOnline {
// for each usedVoucher if has connection and not updated online, update online
    NSArray* eventIdArray = _usedVoucherDict.allKeys;
    for (NSString* eventId in eventIdArray ) {
        UsedVoucher *usedVoucher = [_usedVoucherDict objectForKey:eventId];

        // check if there is internet connection
        KSJson * json = [[KSJson alloc] init];
        if ([json isConnectionAvailable]){

            // check if it is used  and not unloaded online, update it online
            if([self isUsed:usedVoucher.eventId] && ![usedVoucher updatedOnline]) {
                NSString *url =  @"model_addVoucher.php?user_id=cloudnineapp-voucher&password=App@Cloud9&event_id=";
                NSString *jsonURL  = [url stringByAppendingString:eventId];
                [json toArray:jsonURL];
                ALog(@" voucher used updated to the url =  %@" ,jsonURL);
                usedVoucher.updatedOnline = (BOOL*) YES ;
            }
        } else {
            ALog(@"no connection:  could not update the voucher" );
        }
    }

    [self save];
}

- (void)addUsedVoucher:(UsedVoucher *)usedVoucher {
    NSString* eventId = usedVoucher.eventId;
    if ([_usedVoucherDict objectForKey:eventId] == nil) {
        [usedVoucher setUsed:(BOOL*)YES];
        [usedVoucher setUpdatedOnline:NO];
        [_usedVoucherDict setValue:usedVoucher forKey:eventId];
    }
    [self updateOnline];
}


#pragma mark PLIST related
- (void) readDict {
    NSString *fiePath = [self getFilePath];
    NSLog (@"%@",fiePath);
    if ([NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:fiePath]] !=nil) {
       _usedVoucherDict =  [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:fiePath]];
    } else{
        _usedVoucherDict =  nil;
    }
}

- (void) save{
    NSString *error;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:_usedVoucherDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:[self getFilePath] atomically:YES];
    } else {
        NSLog(error);
    }
}


- (BOOL *) isUsed:(NSString *)eventId {
    if (_usedVoucherDict != nil) {
        UsedVoucher *usedVoucher = [_usedVoucherDict objectForKey:eventId];
        return usedVoucher.used;
    }  else {
        return NO;
    }
}


- (NSString *) getFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *filePath = [basePath stringByAppendingPathComponent:@"voucher.plist"];
    return filePath;
}


@end