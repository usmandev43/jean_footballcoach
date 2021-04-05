//
//  CoachesListViewController.m
//  harbaughsim16
//
//  Created by M.Usman on 26/02/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import "CoachesListViewController.h"
#import "CoachesListCell.h"
#import "CoachesCommonModel.h"
#import "CoachConfirmationPopupVC.h"
#import "STPopup.h"
#import "Team.h"
#import "HBSharedUtils.h"

@interface CoachesListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    STPopupController *popupController;
    Team *userTeam;
}

@end

@implementation CoachesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userTeam = [HBSharedUtils getLeague].userTeam;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popAlertAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.title = @"Coaches List";
    // Do any additional setup after loading the view from its nib.
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CoachesListCell" bundle:nil] forCellReuseIdentifier:@"CoachesListCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)popAlertAction:(UIBarButtonItem*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoachesListCell *cell = (CoachesListCell*)[tableView dequeueReusableCellWithIdentifier:@"CoachesListCell"];
    CoachesModel *coach =  ((CoachesModel*)self.coacheslevelArr[indexPath.row]);
    
    cell.NameLabel.text = [NSString stringWithFormat:@"%@\n%@",coach.First,coach.Last];

    cell.aplusLabel.text = coach.ratDef;//coaches.ratPot;
    cell.bplusLabel.text = coach.ratDev;
    cell.cplusLabel.text = coach.ratDisc;
    cell.dplusLabel.text = coach.ratOff;
    cell.eplusLabel.text = coach.ratPot;
    cell.cost.text = [NSString stringWithFormat:@"%i ₡",[coach.Cost intValue]];
    cell.hireFireButton.tag = indexPath.section;
    CoachesModel *selectedCoach = [userTeam checkSelectedCoachesHaveSamePosition:coach.Position];
    if(selectedCoach != nil && [selectedCoach.First isEqualToString:coach.First]){
        [cell.hireFireButton setTitle:@"Fire" forState:UIControlStateNormal];
        [cell.hireFireButton setBackgroundColor:[HBSharedUtils champColor]];
    }else{
        [cell.hireFireButton setTitle:@"Hire" forState:UIControlStateNormal];
        [cell.hireFireButton setBackgroundColor:[HBSharedUtils hireColor]];
        
    }
    [cell.hireFireButton addTarget:self action:@selector(hireFireButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.widthConst.constant = 60;
    [cell.cost setAlpha:1];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CoachesModel *coach =  ((CoachesModel*)self.coacheslevelArr[indexPath.row]);
    
    CoachesModel *selectedCoach = [userTeam checkSelectedCoachesHaveSamePosition:coach.Position];
    if(selectedCoach != nil && [selectedCoach.First isEqualToString:coach.First]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure you want to Fire Coach?"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) {
                    
        }];
        UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) {
            [userTeam.coach removeObject:selectedCoach];
            [userTeam.league saveselectedCoach:userTeam.coach];
            [self.tableView reloadData];
            return;
        }];

            [alert addAction:defaultAction];
            [alert addAction:defaultAction2];
            [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        CoachConfirmationPopupVC *vc = [[CoachConfirmationPopupVC alloc] init];
        vc.coachModel = coach;
        popupController = [[STPopupController alloc] initWithRootViewController:vc];
        [popupController.navigationBar setDraggable:YES];
        [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
        popupController.style = STPopupStyleFormSheet;
    //    [popupController.navigationBar setHidden:YES];
    //    [popupController.containerView setBackgroundColor:[UIColor clearColor]];
        [popupController presentInViewController:self];
    }
    
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)hireFireButtonAction:(UIButton *)sender{
    
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
