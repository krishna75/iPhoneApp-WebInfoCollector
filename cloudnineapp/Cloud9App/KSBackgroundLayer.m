//
//  KSBackgroundLayer.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 04/07/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSBackgroundLayer.h"

@implementation KSBackgroundLayer

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.25 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.00 saturation:0.0 brightness:0.15 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.00 saturation:0.0 brightness:0.10 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.00 saturation:0.0 brightness:0.05 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.25];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.50];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

@end
