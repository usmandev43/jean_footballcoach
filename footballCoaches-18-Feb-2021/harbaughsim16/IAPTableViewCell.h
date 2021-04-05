//
//  IAPTableViewCell.h
//  harbaughsim16
//
//  Created by M.Usman on 19/03/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;

@end

NS_ASSUME_NONNULL_END
