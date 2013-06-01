//
//  KSCell.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 01/06/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSCell : UITableViewCell {
    UILabel *titleLabel;
    UILabel *descriptionLabel;
    UILabel *moreLabel;
    UIImageView *imageView;
}
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *descriptionLabel;
@property(nonatomic,retain)UILabel *moreLabel;

@property(nonatomic,retain)UIImageView *imageView;

@end
