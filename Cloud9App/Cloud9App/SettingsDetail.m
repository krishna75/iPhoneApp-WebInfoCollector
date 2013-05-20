//
//  SettingsDetail.m
//  Cloud9App
//
//  Created by nerd on 01/05/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "SettingsDetail.h"
#import "AppDelegate.h"

@interface SettingsDetail ()

@end

@implementation SettingsDetail
@synthesize urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    
    NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[settingsWeb loadRequest:requestObj];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [app AddloadingView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView  {
    [app RemoveLoadingView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
