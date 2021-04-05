//
//  TeamStrategyViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/22/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamStrategyViewController.h"
#import "TeamStrategy.h"
#import "Team.h"

#import "STPopup.h"

@interface TeamStrategyViewController ()
{
    NSArray *teamStrats;
    NSIndexPath *selectedIndexPath;
    BOOL isOffense;
}
@end

@implementation TeamStrategyViewController

-(instancetype)initWithType:(BOOL)offensive options:(NSArray<TeamStrategy*> *)options {
    self = [super init];
    if (self) {
        isOffense = offensive;
        if (isOffense) {
            self.title = @"Offensive Playbooks";
            selectedIndexPath = [NSIndexPath indexPathForRow:[HBSharedUtils getLeague].userTeam.teamStatOffNum inSection:0];
        } else {
            self.title = @"Defensive Playbooks";
            selectedIndexPath = [NSIndexPath indexPathForRow:[HBSharedUtils getLeague].userTeam.teamStatDefNum inSection:0];
        }
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 10 + (options.count * 90));
        teamStrats = options;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 90;
    self.tableView.estimatedRowHeight = 90;
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return teamStrats.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.detailTextLabel setNumberOfLines:0];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    TeamStrategy *strat = teamStrats[indexPath.row];
    [cell.textLabel setText:strat.stratName];
    [cell.detailTextLabel setText:strat.stratDescription];
    [cell.detailTextLabel sizeToFit];
    
    if(selectedIndexPath) {
        if (indexPath.row == selectedIndexPath.row && indexPath.section == selectedIndexPath.section) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([selectedIndexPath isEqual:indexPath]) {
        selectedIndexPath = nil;
    } else {
        selectedIndexPath = indexPath;
    }
    
    if(isOffense) {
        [[HBSharedUtils getLeague].userTeam setOffensiveStrategy:teamStrats[indexPath.row]];
        [[HBSharedUtils getLeague].userTeam setTeamStatOffNum:(int)indexPath.row];
    } else {
        [[HBSharedUtils getLeague].userTeam setDefensiveStrategy:teamStrats[indexPath.row]];
        [[HBSharedUtils getLeague].userTeam setTeamStatDefNum:(int)indexPath.row];
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changedStrategy" object:nil];
    [[HBSharedUtils getLeague] save];
}

@end
