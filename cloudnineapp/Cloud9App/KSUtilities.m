//
//  KSUtilities.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 09/03/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSUtilities.h"
#import "KSGuiUtilities.h"
#import <QuartzCore/QuartzCore.h>


#define kDefaultFont @"Helvetica"

@implementation KSUtilities

+ (NSString *) getDefaultFont{
    return kDefaultFont;
}

// creates a formatted string for the date
+ (NSMutableString *) getFormatedDate:(NSString *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *formattedDate= [dateFormatter dateFromString:date];
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay= [prefixDateFormatter stringFromDate:formattedDate];
    
    [prefixDateFormatter setDateFormat:@"d"];
    NSString *dateDay= [prefixDateFormatter stringFromDate:formattedDate];
    
    [prefixDateFormatter setDateFormat:@"MMMM"];
    NSString *month=[prefixDateFormatter stringFromDate:formattedDate];
    
    int date_day = [dateDay  intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    
    return [NSMutableString stringWithFormat:@"%@, %@%@ %@", weekDay,dateDay,suffix,month];
}

+ (NSDictionary *)getDateDict:(NSString *) date {

    NSMutableDictionary *dateDict = [[NSMutableDictionary alloc]init];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *formattedDate= [dateFormatter dateFromString:date];

    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay= [prefixDateFormatter stringFromDate:formattedDate];
    [dateDict setObject:weekDay forKey:@"weekDay"];

    [prefixDateFormatter setDateFormat:@"d"];
    NSString *dateDay= [prefixDateFormatter stringFromDate:formattedDate];
    [dateDict setObject:dateDay forKey:@"dateDay"];

    int date_day = [dateDay  intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    [dateDict setObject:suffix forKey:@"suffix"];

    [prefixDateFormatter setDateFormat:@"MMM"];
    NSString *shortMonth =[prefixDateFormatter stringFromDate:formattedDate];
    [dateDict setObject:[shortMonth uppercaseString] forKey:@"shortMonth"];

    [prefixDateFormatter setDateFormat:@"MMMM"];
    NSString *longMonth=[prefixDateFormatter stringFromDate:formattedDate];
    [dateDict setObject:longMonth forKey:@"longMonth"];

    return dateDict ;
}

// create the parent view that will hold header Label
+ (UIView *) getHeaderView:(UIImage*) logoImage forTitle:(NSString *)titleText forDetail:(NSString *)description {
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10,0,300,60)] ;

    // background image
    UIGraphicsBeginImageContext(customView.frame.size);
    UIImage *bgImage = [UIImage imageNamed:@"table_header.png"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:bgImage];
    [customView addSubview:imageView1];

    // create title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.frame = CGRectMake(70,18,200,20);
    titleLabel.textColor = [self colorWithHexString:@"FF8330"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text =  titleText;

    // create description label
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textColor = [self colorWithHexString:@"5E5E5E"];
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.frame = CGRectMake(70,33,230,25);
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    NSString *trimmedDescription = [description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    descriptionLabel.text = trimmedDescription;

    // logo image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logoImage];
    imageView.frame = CGRectMake(10,10,50,50);

    [customView addSubview:imageView];
    [customView addSubview:titleLabel];
    [customView addSubview:descriptionLabel];

    return customView;
}

// create the parent view that will hold header Label
+ (UIButton*)getBackButton {

UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
UIImage *btnImg = [UIImage imageNamed:@"backButton.png"];
[btn setBackgroundImage:btnImg forState:UIControlStateNormal];
[btn setTitle:@"Back" forState:UIControlStateNormal];
btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
btn.titleLabel.font = [UIFont fontWithName:kDefaultFont size:12] ;

btn.frame = CGRectMake(0, 0, 45, 25);

return btn;
}

+ (UIImageView *) getCalendar:(NSString *) month forDay:(NSString *)day {
    UIImage *calendarImage = [UIImage imageNamed:@"calendar_empty.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:calendarImage];
//    UIImageView *imageView = [[UIImageView alloc] init];

    imageView.frame = CGRectMake(0, 0, 73, 73);

    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 70, 15)] ;
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.textColor = [self colorWithHexString:@"FF8330"];
    monthLabel.font = [UIFont fontWithName:kDefaultFont size:16.0];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.text = month;
    [imageView addSubview:monthLabel];


    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 70, 45)] ;
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.textColor = [self colorWithHexString:@"5E5E5E"];
    dayLabel.font = [UIFont fontWithName:kDefaultFont size:40.0];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.text = day;
    [imageView addSubview:dayLabel];

    return imageView;
}

+ (UIImage *) getImage: (NSString *) strUrlForImage {

    UIImage* image = [KSGuiUtilities loadImage:strUrlForImage] ;
    if (image == nil ) {
        NSLog(@"no local image found for %@ !",strUrlForImage) ;
        NSURL *imageURL = [NSURL URLWithString:strUrlForImage];
        NSData  *imageData = [NSData dataWithContentsOfURL:imageURL];
        image = [[UIImage alloc] initWithData:imageData];
        [KSGuiUtilities saveImage:image forName:strUrlForImage];
    } else {
        NSLog(@"local image found for %@ :-)",strUrlForImage) ;
    }
    return image;
}

+ (UIImageView *) getImageViewOfUrl:(NSString *) strUrlForImage {
    UIImage* image = [self getImage:strUrlForImage];
    return [KSUtilities getResizedImageViewForCell:image];
}


+ (UIImageView *) getResizedImageViewForCell:(UIImage *) logoImage {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logoImage];
    imageView.frame = CGRectMake(0, 0, 73, 73);
    return imageView;
}

+ (NSString *) getToday {
    NSDate *now = [NSDate date];
    NSString *strDate = [[NSString alloc] initWithFormat:@"%@",now];
    NSArray *arr = [strDate componentsSeparatedByString:@" "];
    return [arr objectAtIndex:0];
}

+ (UIView *) getBadgeLikeView: (NSString *)strToDisplay showHide:(BOOL)show {
    int len = strToDisplay.length * 10;
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(280-len,25,len+30,30)] ;
    [v.layer setCornerRadius:8];
    [v.layer setBorderWidth:0];

    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectInset(v.bounds, 2, 2);
    label.layer.cornerRadius = 10;
    label.text = strToDisplay;
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font=[UIFont fontWithName:kDefaultFont size:18];
    
    //gradient look for background
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    if(show)
        [v setHidden:NO];
    else
        [v setHidden:YES];
    [v addSubview:label];
    
    return v;
}

+(UIView *)removeBadgeLikeView:(NSString *)strToDisplay {
    int len = strToDisplay.length * 10;
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(50-len,2,len+10,20)] ;
    v.backgroundColor = [UIColor clearColor];
    return v;
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSString *)toPlainString:(NSString *)complexString {
    NSString* plainString = [complexString stringByReplacingOccurrencesOfString:@"/" withString:@"_"] ;
    plainString = [plainString stringByReplacingOccurrencesOfString:@":" withString:@"_"] ;
    plainString = [plainString stringByReplacingOccurrencesOfString:@"." withString:@"_"] ;
    return plainString;
}




@end


