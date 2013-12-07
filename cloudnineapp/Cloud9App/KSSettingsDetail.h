//
//  KSSettingsDetail.h
//  Cloud9App
//
//  Created by nerd on 01/05/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSSettingsDetail : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView *settingsWeb;
    NSString *urlString;
}
@property(nonatomic,retain)  NSString *urlString;

@end
