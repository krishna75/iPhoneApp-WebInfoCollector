//
//  KSCell.m
//  Cloud9App
//
//  Created by Krishna Sapkota on 01/06/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import "KSCell.h"
#import "KSUtilities.h"

@implementation KSCell

@synthesize titleLabel,descriptionLabel, moreLabel, imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
                
        // create title label
        titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [KSUtilities colorWithHexString:@"FFFFFF"];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        // create description label
        descriptionLabel = [[UILabel alloc]init];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textColor = [KSUtilities colorWithHexString:@"C8C8C1"];
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        descriptionLabel.textAlignment = NSTextAlignmentLeft;
        
        // create description label
        moreLabel = [[UILabel alloc]init];
        moreLabel.backgroundColor = [UIColor clearColor];
        moreLabel.textColor = [KSUtilities colorWithHexString:@"C9C9C1"];
        moreLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        moreLabel.textAlignment = NSTextAlignmentLeft;

        imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:descriptionLabel];
        [self.contentView addSubview:moreLabel];
        [self.contentView addSubview:imageView];

    }
    return self;
}

- (void)layoutSubviews {
        
    [super layoutSubviews];
    // background image
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:@"bg_cell.png"] drawInRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    frame= CGRectMake(boundsX+10 ,0, 50, 50);
    imageView.frame = frame;

    frame= CGRectMake(boundsX+80 ,5, 250, 25);
    titleLabel.frame = frame;

    frame= CGRectMake(boundsX+80 ,30, 250, 15);
    descriptionLabel.frame = frame;

    frame= CGRectMake(boundsX+80 ,45, 250, 15);
    moreLabel.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
