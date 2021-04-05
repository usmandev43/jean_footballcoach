//
//  CoachesLevelViewController.m
//  harbaughsim16
//
//  Created by M.Usman on 26/02/2021.
//  Copyright © 2021 Akshay Easwaran. All rights reserved.
//

#import "CoachesLevelViewController.h"
#import "CoachStarLevelCell.h"
#import "HBSharedUtils.h"
#import "CoachesListViewController.h"
@interface CoachesLevelViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CoachesLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popAlertAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.title = @"Coaches Level";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CoachStarLevelCell" bundle:nil] forCellReuseIdentifier:@"CoachStarLevelCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)popAlertAction:(UIBarButtonItem*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.coacheslevelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoachStarLevelCell *cell = (CoachStarLevelCell*)[tableView dequeueReusableCellWithIdentifier:@"CoachStarLevelCell"];
    CoachesLevelModel *level = self.coacheslevelArr[indexPath.row];
    if(indexPath.row == 0){
        cell.starLabel.text = level.title;
        [cell.staar1 setHidden:NO];
        [cell.star2 setHidden:YES];
        [cell.star3 setHidden:YES];
        [cell.star4 setHidden:YES];
        [cell.star5 setHidden:YES];
    }else if(indexPath.row == 1){
        cell.starLabel.text = level.title;
        [cell.staar1 setHidden:NO];
        [cell.star2 setHidden:NO];
        [cell.star3 setHidden:YES];
        [cell.star4 setHidden:YES];
        [cell.star5 setHidden:YES];
    }else if(indexPath.row == 2){
        cell.starLabel.text = level.title;
        [cell.staar1 setHidden:NO];
        [cell.star2 setHidden:NO];
        [cell.star3 setHidden:NO];
        [cell.star4 setHidden:YES];
        [cell.star5 setHidden:YES];
    }else if(indexPath.row == 3){
        cell.starLabel.text = level.title;
        [cell.staar1 setHidden:NO];
        [cell.star2 setHidden:NO];
        [cell.star3 setHidden:NO];
        [cell.star4 setHidden:NO];
        [cell.star5 setHidden:YES];
    }else if(indexPath.row == 4){
        cell.starLabel.text = level.title;
        [cell.staar1 setHidden:NO];
        [cell.star2 setHidden:NO];
        [cell.star3 setHidden:NO];
        [cell.star4 setHidden:NO];
        [cell.star5 setHidden:NO];
    }else{
        cell.starLabel.text = level.title;
        [cell.staar1 setHidden:NO];
        [cell.star2 setHidden:NO];
        [cell.star3 setHidden:NO];
        [cell.star4 setHidden:NO];
        [cell.star5 setHidden:NO];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [HBSharedUtils getScreenWidth], 60)];
    view.backgroundColor = [HBSharedUtils styleColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, [HBSharedUtils getScreenWidth] - 16, 40)];
    label.text = @"Select Coaches Level";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CoachesListViewController *vc = [[CoachesListViewController alloc] init];
    CoachesLevelModel *level = self.coacheslevelArr[indexPath.row];
    vc.coacheslevelArr = level.coach;
    [self.navigationController pushViewController:vc animated:YES];
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
