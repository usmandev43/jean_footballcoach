//
//  CoachesHeaderCell.h
//  harbaughsim16
//
//  Created by D2Vision on 28/11/2020.
//  Copyright © 2020 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoachesHeaderCell : UIView
@property (strong, nonatomic) IBOutlet UILabel *coacheHeaderLabel;
@property (weak, nonatomic) IBOutlet UIButton *hireBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

NS_ASSUME_NONNULL_END
