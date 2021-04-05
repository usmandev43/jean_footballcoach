//
//  CoachesListCell.h
//  harbaughsim16
//
//  Created by M.Usman on 26/02/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoachesListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *NameLabel;
@property (strong, nonatomic) IBOutlet UIButton *hireFireButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *aplusLabel;
@property (strong, nonatomic) IBOutlet UILabel *bplusLabel;
@property (strong, nonatomic) IBOutlet UILabel *cplusLabel;
@property (strong, nonatomic) IBOutlet UILabel *dplusLabel;
@property (strong, nonatomic) IBOutlet UILabel *eplusLabel;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConst;

@end

NS_ASSUME_NONNULL_END
