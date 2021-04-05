//
//  HBStatsCell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@interface HBRosterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;
@property (weak, nonatomic) IBOutlet UILabel *letterGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yrLabel;
@property (weak, nonatomic) IBOutlet UILabel *ovrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *medImageView;
@end
