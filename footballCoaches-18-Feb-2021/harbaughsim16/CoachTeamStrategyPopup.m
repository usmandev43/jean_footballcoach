//
//  CoachTeamStrategyPopup.m
//  harbaughsim16
//
//  Created by M.Usman on 06/03/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import "CoachTeamStrategyPopup.h"
#import "STPopup.h"
#import "HBSharedUtils.h"
#import "Team.h"

@interface CoachTeamStrategyPopup (){
    Team *userTeam;
}

@end

@implementation CoachTeamStrategyPopup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self designUI];
    // Do any additional setup after loading the view from its nib.
    self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 280);
}

-(void)designUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [[HBSharedUtils styleColor] CGColor];
    self.yesBtn.layer.cornerRadius = 8;
    self.yesBtn.backgroundColor = [HBSharedUtils styleColor];
    userTeam = [HBSharedUtils getLeague].userTeam;
    NSArray *offStrategy = [userTeam getOffensiveTeamStrategiesWithVariables];
    NSArray *defStrategy = [userTeam getDefensiveTeamStrategiesVariables];
    
    self.off1.text = offStrategy[0];
    self.off2.text = offStrategy[1];
    self.off3.text = offStrategy[2];
    self.off4.text = offStrategy[3];
    self.off5.text = offStrategy[4];
    self.off6.text = offStrategy[5];
    self.off7.text = offStrategy[6];
    self.off8.text = offStrategy[7];
    
    self.def1.text = defStrategy[0];
    self.def2.text = defStrategy[1];
    self.def3.text = defStrategy[2];
    self.def4.text = defStrategy[3];
    self.def5.text = defStrategy[4];
    self.def6.text = defStrategy[5];
    self.def7.text = defStrategy[6];
    self.def8.text = defStrategy[7];
    
}


- (IBAction)yesBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
