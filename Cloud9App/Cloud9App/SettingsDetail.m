//
//  SettingsDetail.m
//  Cloud9App
//
//  Created by nerd on 01/05/13.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "SettingsDetail.h"
#import "AppDelegate.h"
#import "KSUtilities.h"

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
    [self setBackButton];
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

#pragma mark - Back button;
-(void) setBackButton {
    UIButton *btn = [KSUtilities getBackButton];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)goBack{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
