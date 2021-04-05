//
//  TeamRosterViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/22/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamRosterViewController.h"
#import "Team.h"
#import "HBRosterCell.h"
#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerTE.h"
#import "PlayerLB.h"
#import "PlayerDL.h"
#import "PlayerCB.h"
#import "PlayerS.h"
#import "PlayerDetailViewController.h"
#import "InjuryReportViewController.h"

#import "HexColors.h"
#import "STPopup.h"

@interface TeamRosterViewController ()
{
    Team *selectedTeam;
    STPopupController *popupController;
}
@end

@implementation TeamRosterViewController

-(instancetype)initWithTeam:(Team*)team {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        selectedTeam = team;
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height / 2.0));
    }
    return self;
}

-(void)viewInjuryReport {
    InjuryReportViewController *injuryVC = [[InjuryReportViewController alloc] initWithTeam:selectedTeam];
    injuryVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:injuryVC] animated:YES completion:nil];
}

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([HBSharedUtils getLeague].isHardMode) {
        [self setToolbarItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc] initWithTitle:@"View Injury Report" style:UIBarButtonItemStylePlain target:self action:@selector(viewInjuryReport)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]]];
        self.navigationController.toolbarHidden = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ Roster",selectedTeam.abbreviation];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBRosterCell" bundle:nil] forCellReuseIdentifier:@"HBRosterCell"];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(scrollToPositionGroup)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

-(void)scrollToPositionGroup {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View a specific position" message:@"Which position would you like to see?" preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.tableView.numberOfSections; i++) {
        NSString *position = @"";
        if (i == 0) {
            position = @"QB";
        } else if (i == 1) {
            position = @"RB";
        } else if (i == 2) {
            position = @"WR";
        } else if (i == 3) {
            position = @"TE";
        } else if (i == 4) {
            position = @"OL";
        } else if (i == 5) {
            position = @"DL";
        } else if (i == 6) {
            position = @"LB";
        } else if (i == 7) {
            position = @"CB";
        } else if (i == 8) {
            position = @"S";
        } else {
            position = @"K";
        }
        [alertController addAction:[UIAlertAction actionWithTitle:position style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.tableView numberOfRowsInSection:i] > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            });
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return selectedTeam.teamQBs.count;
    } else if (section == 1) {
        return selectedTeam.teamRBs.count;
    } else if (section == 2) {
        return selectedTeam.teamWRs.count;
    } else if (section == 3) {
        return selectedTeam.teamTEs.count;
    } else if (section == 4) {
        return selectedTeam.teamOLs.count;
    } else if (section == 5) {
        return selectedTeam.teamDLs.count;
    } else if (section == 6) {
        return selectedTeam.teamLBs.count;
    } else if (section == 7) {
        return selectedTeam.teamCBs.count;
    } else if (section == 8) {
        return selectedTeam.teamSs.count;
    } else {
        return selectedTeam.teamKs.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"QB";
    } else if (section == 1) {
        return @"RB";
    } else if (section == 2) {
        return @"WR";
    } else if (section == 3) {
        return @"TE";
    } else if (section == 4) {
        return @"OL";
    } else if (section == 5) {
        return @"DL";
    } else if (section == 6) {
        return @"LB";
    } else if (section == 7) {
        return @"CB";
    } else if (section == 8) {
        return @"S";
    } else {
        return @"K";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBRosterCell *cell = (HBRosterCell*)[tableView dequeueReusableCellWithIdentifier:@"HBRosterCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    Player *player;
    if (indexPath.section == 0) {
        player = [selectedTeam getQB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 1) {
        player = [selectedTeam getRB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 2) {
        player = [selectedTeam getWR:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 3) {
        player = [selectedTeam getTE:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 4) {
        player = [selectedTeam getOL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 5) {
        player = [selectedTeam getDL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 6) {
        player = [selectedTeam getLB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 7) {
        player = [selectedTeam getCB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 8) {
        player = [selectedTeam getS:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else {
        player = [selectedTeam getK:[NSNumber numberWithInteger:indexPath.row].intValue];
    }
    
    [cell.nameLabel setText:[player getInitialName]];
    [cell.yrLabel setText:[player getYearString]];
    [cell.ovrLabel setText:[NSString stringWithFormat:@"%d", player.ratOvr]];
    if (player.hasRedshirt) {
        [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
    } else if (player.isHeisman) {
        [cell.nameLabel setTextColor:[HBSharedUtils champColor]];
    } else if (player.isAllAmerican) {
        [cell.nameLabel setTextColor:[UIColor orangeColor]];
    } else if (player.isAllConference) {
        [cell.nameLabel setTextColor:[HBSharedUtils successColor]];
    } else {
        [cell.nameLabel setTextColor:[UIColor blackColor]];
    }
    
    if ([player isInjured]) {
        [cell.medImageView setHidden:NO];
    } else {
        [cell.medImageView setHidden:YES];
    }
    return cell;
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Player *player;
    if (indexPath.section == 0) {
        player = [selectedTeam getQB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 1) {
        player = [selectedTeam getRB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 2) {
        player = [selectedTeam getWR:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 3) {
        player = [selectedTeam getTE:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 4) {
        player = [selectedTeam getOL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 5) {
        player = [selectedTeam getDL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 6) {
        player = [selectedTeam getLB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 7) {
        player = [selectedTeam getCB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 8) {
        player = [selectedTeam getS:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else {
        player = [selectedTeam getK:[NSNumber numberWithInteger:indexPath.row].intValue];
    }
    
    if (!_isPopup) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerDetailViewController alloc] initWithPlayer:player]];
        [popupController.navigationBar setDraggable:YES];
        [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    } else {
        [self.popupController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:player] animated:YES];
    }
}


@end
