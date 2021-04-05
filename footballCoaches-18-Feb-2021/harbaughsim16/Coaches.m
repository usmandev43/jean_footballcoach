//
//  Coaches.m
//  harbaughsim16
//
//  Created by D2Vision on 28/11/2020.
//  Copyright © 2020 Akshay Easwaran. All rights reserved.
//

#import "Coaches.h"
#import "CoachesCell.h"
#import "CoachesHeaderCell.h"
#import "CoachesData.h"
#import "HBSharedUtils.h"
#import "CoachesLevelViewController.h"
#import "Team.h"
#import "CoachTeamStrategyPopup.h"
#import "STPopup.h"
#import "IAPurchaceViewController.h"
@interface Coaches ()<UITableViewDelegate,UITableViewDataSource,IAPurchaceViewControllerDelegate>{
    Team *userTeam;
//    Player *heisman;
    NSArray *stats;
    CoachesModel *selectedCoach;
    STPopupController *popupController;
}

@property (strong, nonatomic) IBOutlet UITableView *coachesTableView;
@property (strong, nonatomic) NSArray *coachesArray;

@end

@implementation Coaches


- (void)viewDidLoad {
    [super viewDidLoad];
    userTeam = [HBSharedUtils getLeague].userTeam;
    stats = [userTeam getTeamStatsArray];
    NSLog(@"Print Variable Values %@",[userTeam getOffensiveTeamStrategiesWithVariables]);
//    heisman = [[HBSharedUtils getLeague] heisman];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"coachesdata" ofType:@"data"];
//    NSData *videoData = [NSData dataWithContentsOfFile:path];
//        NSError *error;
//       _coachesArray = [NSKeyedUnarchiver unarchivedArrayOfObjectsOfClass:[CoachesData class] fromData:videoData error:&error];
    self.coachesTableView.tableHeaderView = [UIView new];
    self.navigationItem.title = @"Coaching Staff";
    
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style: UIBarButtonSystemItemFlexibleSpace target:self action:@selector(Back)];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popAlertAction:)];
//        self.navigationItem.leftBarButtonItem = backButton;
//        self.navigationItem.leftBarButtonItem = backButton;
    _coachesTableView.delegate = self;
    _coachesTableView.dataSource = self;
    [self.coachesTableView registerNib:[UINib nibWithNibName:@"CoachesCell" bundle:nil] forCellReuseIdentifier:@"CoachesCell"];
//    [self.coachesTableView registerNib:[UINib nibWithNibName:@"CoachesHeaderCell" bundle:nil] forCellReuseIdentifier:@"CoachesHeaderCell"];
    
    
    [self getCoachesData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.coachesTableView reloadData];
    
    self.moneyLbl.text = [NSString stringWithFormat:@"%d₡\nBuy More",userTeam.teamBudget];
    self.moneyLbl.textColor = [HBSharedUtils styleColor];
}

//MARK:- Get Dummy Data
-(void)getCoachesData{
   CoachesCommonModel *model = [HBSharedUtils getCoachesData];
    _coachesArray = [[NSMutableArray alloc] initWithArray:model.data];
    [self.coachesTableView reloadData];
}

- (void)popAlertAction:(UIBarButtonItem*)sender
{
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _coachesArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoachesCell *cell = (CoachesCell*)[tableView dequeueReusableCellWithIdentifier:@"CoachesCell"];
    if(indexPath.section == 0){
        cell.NameLabel.text = [NSString stringWithFormat:@"%@",userTeam.name];
        cell.aplusLabel.text = [HBSharedUtils getLetterGrade:userTeam.teamOffTalent];
        cell.bplusLabel.text = [HBSharedUtils getLetterGrade:userTeam.teamDefTalent];
        cell.cplusLabel.text = [HBSharedUtils getLetterGrade:userTeam.teamTODiff];
        cell.dplusLabel.text = [HBSharedUtils getLetterGrade:userTeam.teamPrestige];
        cell.eplusLabel.text = [HBSharedUtils getLetterGrade:userTeam.teamPollScore];;
        [cell.hireFireButton setHidden:YES];
    }else{
        CoachesPositionModel *position =  ((CoachesPositionModel*)_coachesArray[indexPath.section - 1]);
//        CoachesLevelModel *level = position.items.firstObject;
//        CoachesModel *coach = level.coach.firstObject;
        CoachesModel *selectedCoach = [userTeam checkSelectedCoachesHaveSamePosition:position.title];
        if(selectedCoach != nil){
            [cell.hireFireButton setHidden:NO];
            [cell.hireFireButton setTitle:@"Fire" forState:UIControlStateNormal];
            [cell.hireFireButton setBackgroundColor:[HBSharedUtils errorColor]];
            cell.NameLabel.text = [NSString stringWithFormat:@"%@ %@",selectedCoach.First,selectedCoach.Last];

            cell.aplusLabel.text = selectedCoach.ratDef;//coaches.ratPot;
            cell.bplusLabel.text = selectedCoach.ratDev;
            cell.cplusLabel.text = selectedCoach.ratDisc;
            cell.dplusLabel.text = selectedCoach.ratOff;
            cell.eplusLabel.text = selectedCoach.ratPot;
        }
        else{
            [cell.hireFireButton setHidden:YES];
            
            cell.NameLabel.text = @"";

            cell.aplusLabel.text = @"";//coach.ratDef;//coaches.ratPot;
            cell.bplusLabel.text = @"";//coach.ratDev;
            cell.cplusLabel.text = @"";//coach.ratDisc;
            cell.dplusLabel.text = @"";//coach.ratOff;
            cell.eplusLabel.text = @"";//coach.ratPot;
        }
        
        cell.hireFireButton.tag = indexPath.section - 1;
        [cell.hireFireButton addTarget:self action:@selector(hireFireButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    cell.widthConst.constant = 0;
    [cell.cost setAlpha:0];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0){
        CoachTeamStrategyPopup *vc = [[CoachTeamStrategyPopup alloc] init];
//        vc.coachModel = coach;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CoachesHeaderCell" owner:self options:nil];
    CoachesHeaderCell *nibView = [subviewArray objectAtIndex:0];
    
    if(section == 0){
        [nibView.hireBtn setHidden:YES];
        nibView.coacheHeaderLabel.text = @"Head Coach";
    }else{
        CoachesPositionModel *position = [_coachesArray objectAtIndex:section-1];
        nibView.coacheHeaderLabel.text = position.title;
        CoachesModel *selectedCoach = [userTeam checkSelectedCoachesHaveSamePosition:position.title];
        if(selectedCoach == nil){
            [nibView.hireBtn setHidden:NO];
            [nibView.bottomView setHidden:NO];
        }else{
//            [nibView.bottomView setHidden:YES];
            [nibView.hireBtn setHidden:YES];
        }
        nibView.hireBtn.tag = section - 1;
        [nibView.hireBtn setBackgroundColor:[HBSharedUtils hireColor]];
        [nibView.hireBtn addTarget:self action:@selector(hireFireButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [nibView setBackgroundColor:[HBSharedUtils styleColor]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [HBSharedUtils getScreenWidth], 50)];
    nibView.frame = view.bounds;
    [view addSubview:nibView];
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        CoachesPositionModel *position = [_coachesArray objectAtIndex:section-1];
        CoachesModel *selectedCoach = [userTeam checkSelectedCoachesHaveSamePosition:position.title];
        if(selectedCoach != nil){
            return 1;
        }
    }
    return 0;
}

-(void)hireFireButtonAction:(UIButton *)sender{
    NSLog(@"sender Tag %li",(long)sender.tag);
    CoachesPositionModel *position = _coachesArray[sender.tag];
    if([sender.currentTitle isEqualToString:@"Fire"]){
        CoachesModel *selectedCoach = [userTeam checkSelectedCoachesHaveSamePosition:position.title];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure you want to Fire Coach?"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) {
                    
        }];
        UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) {
            [userTeam.coach removeObject:selectedCoach];
            [userTeam.league saveselectedCoach:userTeam.coach];
            [self.coachesTableView reloadData];
            return;
        }];

            [alert addAction:defaultAction];
            [alert addAction:defaultAction2];
            [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        CoachesLevelViewController *vc = [[CoachesLevelViewController alloc] init];
        vc.coacheslevelArr = position.items;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)buyMoreCreditsBtnAction:(id)sender {
    IAPurchaceViewController *vc = [[IAPurchaceViewController alloc] init];
    vc.delegate = self;
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }

        [topRootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)didPurchasedSccess:(NSInteger)selectedIndex {
    if(selectedIndex == 0){
        userTeam.teamBudget = userTeam.teamBudget + 1000;
    }else if (selectedIndex == 1){
        userTeam.teamBudget = userTeam.teamBudget + 5000;
    }else{
        userTeam.teamBudget = userTeam.teamBudget + 10000;
    }
    [userTeam.league saveTeamBuget:userTeam.teamBudget];
    
    self.moneyLbl.text = [NSString stringWithFormat:@"%d₡\nBuy More",userTeam.teamBudget];
    self.moneyLbl.textColor = [HBSharedUtils styleColor];
}


@end
