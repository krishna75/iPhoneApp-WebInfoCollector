//
//  KrishnaCell.h
//  Cloud9App
//
//  Created by Krishna Sapkota on 17/02/2013.
//  Copyright (c) 2013 Krishna Sapkota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KrishnaCell : UITableViewCell {
    
    
}
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UILabel* subTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView* cellImage;
@property (nonatomic, retain) IBOutlet UIView* badgeLikeView;
@end

