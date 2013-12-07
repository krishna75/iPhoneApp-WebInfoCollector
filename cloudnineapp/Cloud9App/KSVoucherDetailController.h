//
//  KSVoucherDetailController.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 03/07/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "KSEventDetail.h"

@interface KSVoucherDetailController : UIViewController <ZBarReaderDelegate> {
    IBOutlet UIButton *scanButton;
    NSDictionary *eventDetailDict;
}

@property (retain, nonatomic) NSDictionary *eventDetailDict;
@property (nonatomic, retain) IBOutlet UIButton *scanButton;
@property (nonatomic, retain) KSEventDetail *eventDetail;

-(IBAction) scanButtonPress:sender;

@end
