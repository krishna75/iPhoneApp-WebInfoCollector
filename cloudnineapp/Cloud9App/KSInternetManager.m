//
// Created by Krishna Sapkota on 23/11/2013.
// Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "KSInternetManager.h"
#import "KSCoreDataManager.h"
#import "Voucher.h"
#import "EventDetail.h"


@implementation KSInternetManager {

}


+ (void)downloadVoucherImages {
    [KSCoreDataManager createVouchers];
    for (Voucher *voucher in [KSCoreDataManager getVouchers]){
        [KSUtilities getImage:voucher.eventDetails.voucherPhoto];
    }
}

+ (BOOL) isConnectionAvailable {
    char *hostname;
    struct hostent *hostinfo;
    hostname = "cnapp.co.uk";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
        return YES;
    }
}

@end