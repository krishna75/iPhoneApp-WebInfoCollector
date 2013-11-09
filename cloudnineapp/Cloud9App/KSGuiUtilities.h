//
//  KSGuiUtilities.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 28/08/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSGuiUtilities : NSObject
+ (UIButton *)buttonWithTitle:(NSString *)title
                       target:(id)target
                     selector:(SEL)selector
                        frame:(CGRect)frame
                        image:(UIImage *)image
                 imagePressed:(UIImage *)imagePressed
                darkTextColor:(BOOL)darkTextColor;

+ (UIImage*)loadImage: (NSString*)imageName;
+ (void)saveImage: (UIImage*)image forName:(NSString*) imageName;

@end
