//
//  IAPurchaceViewController.h
//  harbaughsim16
//
//  Created by M.Usman on 19/03/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IAPurchaceViewControllerDelegate <NSObject>

    -(void)didPurchasedSccess:(NSInteger)selectedIndex;

@end

@interface IAPurchaceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;

@property(nonatomic, weak, nullable) id <IAPurchaceViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
