//
//  KSTabBarController.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 31/08/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSTabBarController.h"

@interface KSTabBarController ()

@end

@implementation KSTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 48);
    UIImage *backgroundImage = [UIImage imageNamed:@"bg_top_nav.png"];
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:frame];
    [imageview setImage:backgroundImage];
    [self.tabBar insertSubview:imageview atIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
