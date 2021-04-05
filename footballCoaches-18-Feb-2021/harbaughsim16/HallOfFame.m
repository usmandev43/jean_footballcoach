//
//  HallOfFame.m
//  harbaughsim16
//
//  Created by D2Vision on 11/11/2020.
//  Copyright © 2020 Akshay Easwaran. All rights reserved.
//

#import "HallOfFame.h"

@interface HallOfFame ()

@end

@implementation HallOfFame

- (void)viewDidLoad {
    [super viewDidLoad];
   // UIBarButtonItem *backBtn =[[UIBarButtonItem alloc] initWithTitle:@"<Back" style:UIBarButtonItemStyleDone target:self action:@selector(popAlertAction:)];
   // self.navigationItem.leftBarButtonItem=backBtn;
    self.navigationItem.title = @"Coach Hall of Fame";
    
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popAlertAction:)];
    
   // [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"backicon.png"]];
   // [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"backicon.png"]];
    self.navigationItem.leftBarButtonItem = button2;
}
- (void)popAlertAction:(UIBarButtonItem*)sender
{
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
