//
//  CoachConfirmationPopupVC.h
//  harbaughsim16
//
//  Created by M.Usman on 27/02/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoachesCommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoachConfirmationPopupVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;

@property (strong, nonatomic) CoachesModel *coachModel;

@end

NS_ASSUME_NONNULL_END
