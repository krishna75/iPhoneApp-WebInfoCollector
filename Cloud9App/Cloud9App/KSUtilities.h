//
//  KSUtilities.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 09/03/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSUtilities : NSObject

+ (NSString *) getDefaultFont;
+ (NSMutableString *) getFormatedDate:(NSString *)date ;
+ (UIView *) getHeaderView:(UIImage *) logoImage forTitle:(NSString *)titleText forDetail:(NSString *)description;
+ (UIButton*)getBackButton;
+ (UIImageView *) getImageViewOfUrl:(NSString *) strUrlForImage ;
+ (UIImageView *) getResizedImageViewForCell:(UIImage *) logoImage;
+ (NSString *) getToday;
+ (UIView *) getBadgeLikeView: (NSString *)strToDisplay showHide:(BOOL)show ;
+(UIView *)removeBadgeLikeView:(NSString *)strToDisplay;
+(UIColor*)colorWithHexString:(NSString*)hex;
+ (UIImageView *) getCalendar:(NSString *) month forDay:(NSString *)day;
+ (NSArray *)getDateComponents:(NSString *) date;

@end
