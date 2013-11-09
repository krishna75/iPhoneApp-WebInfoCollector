//
//  AppDelegate.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//
#define kLoadingTag 101

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate
@synthesize setBadge;
 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    setBadge = true;

    return YES;
}



-(void)AddloadingView {
    

    loadingView=[[UIView alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,480.0)];
    loadingView.backgroundColor=[UIColor clearColor];
    loadingView.tag=kLoadingTag;
    [self.window addSubview:loadingView];
    loadingView.layer.cornerRadius=4.0;
    
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,loadingView.frame.size.width,loadingView.frame.size.height)];
    [loadingView addSubview:img];
    img.image=[UIImage imageNamed:@"loader.png"];
    img.backgroundColor=[UIColor whiteColor];
    
    
	UIActivityIndicatorView *activityIndicatorView =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loadingView addSubview:activityIndicatorView];
	activityIndicatorView.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |	UIViewAutoresizingFlexibleTopMargin |
	UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
    activityIndicatorView.center=CGPointMake(loadingView.frame.size.width/2,loadingView.frame.size.height/2);
    
}

-(void)RemoveLoadingView {
    
    UIView *viewToRemove=(UIView *)[self.window viewWithTag:kLoadingTag];
    if(viewToRemove) {
        
        [viewToRemove removeFromSuperview];
    }
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.

}

- (void)applicationWillEnterForeground:(UIApplication *)application{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{


}

@end
