//
//  KSGuiUtilities.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 28/08/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSGuiUtilities.h"


@implementation KSGuiUtilities

+ (UIButton *)buttonWithTitle:(NSString *)title
                       target:(id)target
                     selector:(SEL)selector
                        frame:(CGRect)frame
                        image:(UIImage *)image
                 imagePressed:(UIImage *)imagePressed
                darkTextColor:(BOOL)darkTextColor
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:[KSUtilities getDefaultFont] size:12]];


    if (darkTextColor) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }  else {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
    UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    // in case the parent view draws with a custom color or gradient, use a transparent color
    button.backgroundColor = [UIColor clearColor];
    
    return button;
}

+ (void)saveImage: (UIImage*)image forName:(NSString*) imageName
{
    if (image != nil)
    {
        imageName = [KSUtilities toPlainString:imageName];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString: imageName ]];

        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}


+ (UIImage*)loadImage: (NSString*)imageName {
    imageName = [KSUtilities toPlainString:imageName];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:imageName]];

    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}



@end
