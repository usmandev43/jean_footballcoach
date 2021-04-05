//
//  CoachConfirmationPopupVC.m
//  harbaughsim16
//
//  Created by M.Usman on 27/02/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import "CoachConfirmationPopupVC.h"
#import "HBSharedUtils.h"
#import "STPopup.h"
#import "Team.h"
#import "IAPurchaceViewController.h"
@interface CoachConfirmationPopupVC ()<IAPurchaceViewControllerDelegate>{
    Team *userTeam;
    League *league;
    NSArray *stats;
}

@end

@implementation CoachConfirmationPopupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 280);
    userTeam = [HBSharedUtils getLeague].userTeam;
    league = userTeam.league;
    [self designUI];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setBackgroundColor:[UIColor clearColor]];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popAlertAction:)];
//    self.navigationItem.leftBarButtonItem = backButton;
//
//    self.title = @"Coaches List";
}

- (void)popAlertAction:(UIBarButtonItem*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)designUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [[HBSharedUtils styleColor] CGColor];
    self.yesBtn.layer.cornerRadius = 8;
    self.noBtn.layer.cornerRadius = 8;
    self.yesBtn.backgroundColor = [HBSharedUtils styleColor];
    self.noBtn.backgroundColor = [HBSharedUtils champColor];
    [self.yesBtn removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
    if(self.coachModel && userTeam){
        NSString *name = [NSString stringWithFormat:@"%@ %@",self.coachModel.First,self.coachModel.Last];
        if([self.coachModel.Cost intValue] <= userTeam.teamBudget){
            self.textLbl.text = [NSString stringWithFormat:@"You have %d₡ (credits) available\nCoach %@ costs %i₡\nConfirm you want to hire him.",userTeam.teamBudget,name,[self.coachModel.Cost intValue]];
            [self.yesBtn setTitle:@"Yes" forState:UIControlStateNormal];
            [self.yesBtn addTarget:self action:@selector(yesBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            self.textLbl.text = [NSString stringWithFormat:@"You have %d₡ (credits) available\nCoach %@ costs %i₡\nYou need to buy more credits for hire a coach.",userTeam.teamBudget,name,[self.coachModel.Cost intValue]];
            [self.yesBtn setTitle:@"Buy Credits" forState:UIControlStateNormal];
            [self.yesBtn addTarget:self action:@selector(buyPrestigeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
}

-(void)buyPrestigeBtnPressed:(UIButton*)sender{
    IAPurchaceViewController *vc = [[IAPurchaceViewController alloc] init];
    vc.delegate = self;
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }

        [topRootViewController presentViewController:vc animated:YES completion:nil];
}

-(void)yesBtnPressed:(UIButton*)sender{
    if(userTeam.coach.count > 0){
        for(int i=0; i<userTeam.coach.count; i++){
            CoachesModel *selectedModel = userTeam.coach[i];
            if([selectedModel.Position isEqualToString:self.coachModel.Position]){
                [userTeam.coach removeObjectAtIndex:i];
            }
        }
    }
    if(userTeam.coach == nil){
        userTeam.coach = [NSMutableArray array];
    }
    userTeam.teamBudget = userTeam.teamBudget - [self.coachModel.Cost intValue];
    [league saveTeamBuget:userTeam.teamBudget];
    [userTeam.coach addObject:self.coachModel];
    [league saveselectedCoach:userTeam.coach];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)noBtnAction:(id)sender {
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

- (void)didPurchasedSccess:(NSInteger)selectedIndex {
    if(selectedIndex == 0){
        userTeam.teamBudget = userTeam.teamBudget + 1000;
    }else if (selectedIndex == 1){
        userTeam.teamBudget = userTeam.teamBudget + 5000;
    }else{
        userTeam.teamBudget = userTeam.teamBudget + 10000;
    }
    [league saveTeamBuget:userTeam.teamBudget];
    
    [self designUI];
}


@end
