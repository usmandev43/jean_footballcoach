//
//  StatDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Player.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerTE.h"
#import "PlayerOL.h"
#import "PlayerLB.h"
#import "PlayerDL.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "HexColors.h"
#import "STPopup.h"

@interface HBPlayerDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yrLabel;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UIImageView *medImageView;
@end
@implementation HBPlayerDetailView
@end

@interface PlayerDetailViewController ()
{
    Player *selectedPlayer;
    IBOutlet HBPlayerDetailView *playerDetailView;
    NSDictionary *stats;
    NSDictionary *careerStats;
    NSDictionary *ratings;
}
@end

@implementation PlayerDetailViewController
-(instancetype)initWithPlayer:(Player*)player {
    self = [super init];
    if(self) {
        selectedPlayer = player;
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height * (3.0/4.0)));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Player";
    [playerDetailView.nameLabel setText:selectedPlayer.name];
    [playerDetailView.yrLabel setText:[NSString stringWithFormat:@"%@ - %@ (Ovr: %d)",[selectedPlayer getFullYearString],selectedPlayer.team.abbreviation,selectedPlayer.ratOvr]];
    [playerDetailView.posLabel setText:selectedPlayer.position];
    self.tableView.tableHeaderView = playerDetailView;
    stats = [selectedPlayer detailedStats:selectedPlayer.gamesPlayedSeason];
    careerStats = [selectedPlayer detailedCareerStats];
    ratings = [selectedPlayer detailedRatings];
    
    if ([selectedPlayer isInjured]) {
        [playerDetailView.medImageView setHidden:NO];
    } else {
        [playerDetailView.medImageView setHidden:YES];
    }
    
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [playerDetailView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)reloadAll {
    [playerDetailView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
        if (section == 1) {
            return @"Career Stats";
        } else {
            return @"Information";
        }
    } else {
        if (section == 1) {
            return @"Season Stats";
        } else if (section == 2) {
            return @"Career Stats";
        } else {
            return @"Information";
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
        if (section == 1) {
            return 36;
        } else {
            return 18;
        }
    } else {
        if (section != 0) {
            return 36;
        } else {
            return 18;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
        if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
            return 2;
        } else {
            return 3;
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
        if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
            return 2;
        } else {
            return 3;
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
        if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
            return 2;
        } else {
            return 3;
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerTE class]]) {
        if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
            return 2;
        } else {
            return 3;
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerDL class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerLB class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
        return 1;
    } else { // PlayerK class
        return 3;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
           return careerStats.allKeys.count;
        } else {
            return stats.allKeys.count;
        }
    } else if (section == 2) {
        return careerStats.allKeys.count;
    } else {
        return (ratings.count + 3);
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
        if (section == 1) {
            return [NSString stringWithFormat:@"Over %ld games", (long)selectedPlayer.gamesPlayed];
        } else {
            return nil;
        }
    } else {
        if (section == 2) {
            return [NSString stringWithFormat:@"Over %ld games", (long)selectedPlayer.gamesPlayed];
        } else if (section == 1) {
            return [NSString stringWithFormat:@"Through %ld games this season", (long)selectedPlayer.gamesPlayedSeason];
        } else {
            return nil;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.detailTextLabel setText:selectedPlayer.personalDetails[@"home_state"]];
            [cell.textLabel setText:@"Home State"];
        } else if (indexPath.row == 1) {
            [cell.detailTextLabel setText:selectedPlayer.personalDetails[@"height"]];
            [cell.textLabel setText:@"Height"];
        } else if (indexPath.row == 2) {
            [cell.detailTextLabel setText:selectedPlayer.personalDetails[@"weight"]];
            [cell.textLabel setText:@"Weight"];
        } else if (indexPath.row == 3) {
            [cell.detailTextLabel setText:ratings[@"potential"]];
            [cell.textLabel setText:@"Potential"];
        } else if (indexPath.row == 4) {
            [cell.detailTextLabel setText:ratings[@"footballIQ"]];
            [cell.textLabel setText:@"Football IQ"];
        } else if (indexPath.row == 5) {
            [cell.detailTextLabel setText:ratings[@"durability"]];
            [cell.textLabel setText:@"Durability"];
        } else {
            if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
                if (indexPath.row == 6) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"passPower"]];
                    [cell.textLabel setText:@"Throwing Power"];
                } else if (indexPath.row == 7) {
                    //acc
                    [cell.detailTextLabel setText:ratings[@"passAccuracy"]];
                    [cell.textLabel setText:@"Throwing Accuracy"];
                } else if (indexPath.row == 8) {
                    //eva
                    [cell.detailTextLabel setText:ratings[@"passEvasion"]];
                    [cell.textLabel setText:@"Evasion"];
                } else {
                    //eva
                    [cell.detailTextLabel setText:ratings[@"rushSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
                if (indexPath.row == 6) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"rushPower"]];
                    [cell.textLabel setText:@"Strength"];
                } else if (indexPath.row == 7) {
                    //spd
                    [cell.detailTextLabel setText:ratings[@"rushSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                } else {
                    //eva
                    [cell.detailTextLabel setText:ratings[@"rushEvasion"]];
                    [cell.textLabel setText:@"Evasion"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
                if (indexPath.row == 6) {
                    //cat
                    [cell.detailTextLabel setText:ratings[@"recCatch"]];
                    [cell.textLabel setText:@"Catching"];
                } else if (indexPath.row == 7) {
                    //spd
                    [cell.detailTextLabel setText:ratings[@"recSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                } else if (indexPath.row == 8) {
                    //blkP
                    [cell.detailTextLabel setText:ratings[@"recEvasion"]];
                    [cell.textLabel setText:@"Evasion"];
                } else {
                    //blkR
                    [cell.detailTextLabel setText:ratings[@"teRunBlk"]];
                    [cell.textLabel setText:@"Run Blocking"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
                if (indexPath.row == 6) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"olPower"]];
                    [cell.textLabel setText:@"Strength"];
                } else if (indexPath.row == 7) {
                    //blkP
                    [cell.detailTextLabel setText:ratings[@"olPassBlock"]];
                    [cell.textLabel setText:@"Pass Blocking"];
                } else if (indexPath.row == 8) {
                    //blkP
                    [cell.detailTextLabel setText:ratings[@"olPassBlock"]];
                    [cell.textLabel setText:@"Pass Blocking"];
                } else {
                    //blkR
                    [cell.detailTextLabel setText:ratings[@"olRunBlock"]];
                    [cell.textLabel setText:@"Run Blocking"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerDL class]]) {
                if (indexPath.row == 6) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"dlPow"]];
                    [cell.textLabel setText:@"Strength"];
                } else if (indexPath.row == 7) {
                    //pass
                    [cell.detailTextLabel setText:ratings[@"dlPass"]];
                    [cell.textLabel setText:@"Pass Pressure"];
                } else {
                    //rsh
                    [cell.detailTextLabel setText:ratings[@"dlRun"]];
                    [cell.textLabel setText:@"Run Stopping"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerLB class]]) {
                if (indexPath.row == 6) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"lbTkl"]];
                    [cell.textLabel setText:@"Tackling"];
                } else if (indexPath.row == 7) {
                    //pass
                    [cell.detailTextLabel setText:ratings[@"lbPass"]];
                    [cell.textLabel setText:@"Pass Pressure"];
                } else {
                    //rsh
                    [cell.detailTextLabel setText:ratings[@"lbRun"]];
                    [cell.textLabel setText:@"Run Stopping"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
                if (indexPath.row == 6) {
                    //cov
                    [cell.detailTextLabel setText:ratings[@"cbCoverage"]];
                    [cell.textLabel setText:@"Coverage Ability"];
                } else if (indexPath.row == 7) {
                    //spd
                    [cell.detailTextLabel setText:ratings[@"cbSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                } else {
                    //tkl
                    [cell.detailTextLabel setText:ratings[@"cbTackling"]];
                    [cell.textLabel setText:@"Tackling Ability"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
                if (indexPath.row == 6) {
                    //cov
                    [cell.detailTextLabel setText:ratings[@"sCoverage"]];
                    [cell.textLabel setText:@"Coverage Ability"];
                } else if (indexPath.row == 7) {
                    //spd
                    [cell.detailTextLabel setText:ratings[@"sSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                } else {
                    //tkl
                    [cell.detailTextLabel setText:ratings[@"sTackling"]];
                    [cell.textLabel setText:@"Tackling Ability"];
                }
            } else { //Ks
                if (indexPath.row == 6) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"kickPower"]];
                    [cell.textLabel setText:@"Kick Power"];
                } else if (indexPath.row == 7) {
                    //acc
                    [cell.detailTextLabel setText:ratings[@"kickAccuracy"]];
                    [cell.textLabel setText:@"Kick Accuracy"];
                } else {
                    //fum
                    [cell.detailTextLabel setText:ratings[@"kickClumsiness"]];
                    [cell.textLabel setText:@"Clumsiness"];
                }
            }
        }
    } else if (indexPath.section == 1) {
        if (selectedPlayer.year > 4 || selectedPlayer.draftPosition != nil) {
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:careerStats[@"heismans"]];
                [cell.textLabel setText:@"Player of the Year Awards"];
            } else if (indexPath.row == 1) {
                [cell.detailTextLabel setText:careerStats[@"allAmericans"]];
                [cell.textLabel setText:@"All-League Nominations"];
            } else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:careerStats[@"allConferences"]];
                [cell.textLabel setText:@"All-Conference Nominations"];
            } else if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
                if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:careerStats[@"completions"]];
                    [cell.textLabel setText:@"Completions"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:careerStats[@"attempts"]];
                    [cell.textLabel setText:@"Pass Attempts"];
                } else if (indexPath.row == 5) {
                    [cell.detailTextLabel setText:careerStats[@"passYards"]];
                    [cell.textLabel setText:@"Pass Yards"];
                } else if (indexPath.row == 6) {
                    [cell.detailTextLabel setText:careerStats[@"completionPercentage"]];
                    [cell.textLabel setText:@"Completion Percentage"];
                } else if (indexPath.row == 7) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerAttempt"]];
                    [cell.textLabel setText:@"Yards Per Attempt"];
                } else if (indexPath.row == 8) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                    [cell.textLabel setText:@"Pass Yards Per Game"];
                } else if (indexPath.row == 9) {
                    [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                    [cell.textLabel setText:@"Pass TDs"];
                } else if (indexPath.row == 10) {
                    [cell.detailTextLabel setText:careerStats[@"interceptions"]];
                    [cell.textLabel setText:@"Interceptions"];
                } else if (indexPath.row == 11) {
                    [cell.detailTextLabel setText:careerStats[@"carries"]];
                    [cell.textLabel setText:@"Carries"];
                } else if (indexPath.row == 12) {
                    [cell.detailTextLabel setText:careerStats[@"rushYards"]];
                    [cell.textLabel setText:@"Rush Yards"];
                } else if (indexPath.row == 13) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerCarry"]];
                    [cell.textLabel setText:@"Rush Yards Per Carry"];
                } else if (indexPath.row == 14) {
                    [cell.detailTextLabel setText:careerStats[@"rushYardsPerGame"]];
                    [cell.textLabel setText:@"Rush Yards Per Game"];
                } else if (indexPath.row == 15) {
                    [cell.detailTextLabel setText:careerStats[@"rushTouchdowns"]];
                    [cell.textLabel setText:@"Rush TDs"];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                    [cell.textLabel setText:@"Fumbles"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
                if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:careerStats[@"carries"]];
                    [cell.textLabel setText:@"Carries"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:careerStats[@"rushYards"]];
                    [cell.textLabel setText:@"Rush Yards"];
                } else if (indexPath.row == 5) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerCarry"]];
                    [cell.textLabel setText:@"Yards Per Carry"];
                } else if (indexPath.row == 6) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                    [cell.textLabel setText:@"Yards Per Game"];
                } else if (indexPath.row == 7) {
                    [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                    [cell.textLabel setText:@"Touchdowns"];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                    [cell.textLabel setText:@"Fumbles"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
                if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:careerStats[@"catches"]];
                    [cell.textLabel setText:@"Catches"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:careerStats[@"recYards"]];
                    [cell.textLabel setText:@"Receiving Yards"];
                } else if (indexPath.row == 5) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerCatch"]];
                    [cell.textLabel setText:@"Yards Per Catch"];
                } else if (indexPath.row == 6) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                    [cell.textLabel setText:@"Yards Per Game"];
                } else if (indexPath.row == 7) {
                    [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                    [cell.textLabel setText:@"Touchdowns"];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                    [cell.textLabel setText:@"Fumbles"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerTE class]]) {
                if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:careerStats[@"catches"]];
                    [cell.textLabel setText:@"Catches"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:careerStats[@"recYards"]];
                    [cell.textLabel setText:@"Receiving Yards"];
                } else if (indexPath.row == 5) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerCatch"]];
                    [cell.textLabel setText:@"Yards Per Catch"];
                } else if (indexPath.row == 6) {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                    [cell.textLabel setText:@"Yards Per Game"];
                } else if (indexPath.row == 7) {
                    [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                    [cell.textLabel setText:@"Touchdowns"];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                    [cell.textLabel setText:@"Fumbles"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
                if (indexPath.row == 3) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"olPower"]];
                    [cell.textLabel setText:@"Strength"];
                } else if (indexPath.row == 4) {
                    //blkP
                    [cell.detailTextLabel setText:ratings[@"olPassBlock"]];
                    [cell.textLabel setText:@"Pass Blocking"];
                } else {
                    //blkR
                    [cell.detailTextLabel setText:ratings[@"olRunBlock"]];
                    [cell.textLabel setText:@"Run Blocking"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerDL class]]) {
                if (indexPath.row == 3) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"dlPow"]];
                    [cell.textLabel setText:@"Strength"];
                } else if (indexPath.row == 4) {
                    //pass
                    [cell.detailTextLabel setText:ratings[@"dlPass"]];
                    [cell.textLabel setText:@"Pass Pressure"];
                } else {
                    //rsh
                    [cell.detailTextLabel setText:ratings[@"dlRun"]];
                    [cell.textLabel setText:@"Run Stopping"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerLB class]]) {
                if (indexPath.row == 3) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"lbTkl"]];
                    [cell.textLabel setText:@"Tackling"];
                } else if (indexPath.row == 4) {
                    //pass
                    [cell.detailTextLabel setText:ratings[@"lbPass"]];
                    [cell.textLabel setText:@"Pass Pressure"];
                } else {
                    //rsh
                    [cell.detailTextLabel setText:ratings[@"lbRun"]];
                    [cell.textLabel setText:@"Run Stopping"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
                if (indexPath.row == 3) {
                    //cov
                    [cell.detailTextLabel setText:ratings[@"cbCoverage"]];
                    [cell.textLabel setText:@"Coverage Ability"];
                } else if (indexPath.row == 4) {
                    //spd
                    [cell.detailTextLabel setText:ratings[@"cbSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                } else {
                    //tkl
                    [cell.detailTextLabel setText:ratings[@"cbTackling"]];
                    [cell.textLabel setText:@"Tackling Ability"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
                if (indexPath.row == 3) {
                    //cov
                    [cell.detailTextLabel setText:ratings[@"sCoverage"]];
                    [cell.textLabel setText:@"Coverage Ability"];
                } else if (indexPath.row == 4) {
                    //spd
                    [cell.detailTextLabel setText:ratings[@"sSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                } else {
                    //tkl
                    [cell.detailTextLabel setText:ratings[@"sTackling"]];
                    [cell.textLabel setText:@"Tackling Ability"];
                }
            } else { //Ks
                if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:careerStats[@"xpMade"]];
                    [cell.textLabel setText:@"XP Made"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:careerStats[@"xpAtt"]];
                    [cell.textLabel setText:@"XP Attempted"];
                } else if (indexPath.row == 5) {
                    [cell.detailTextLabel setText:careerStats[@"xpPercentage"]];
                    [cell.textLabel setText:@"XP Percentage"];
                } else if (indexPath.row == 6) {
                    [cell.detailTextLabel setText:careerStats[@"fgMade"]];
                    [cell.textLabel setText:@"FG Made"];
                } else if (indexPath.row == 7) {
                    [cell.detailTextLabel setText:careerStats[@"fgAtt"]];
                    [cell.textLabel setText:@"FG Attempted"];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fgPercentage"]];
                    [cell.textLabel setText:@"FG Percentage"];
                }
            }
        } else {
            if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
                if (indexPath.row == 0) {
                    [cell.detailTextLabel setText:stats[@"completions"]];
                    [cell.textLabel setText:@"Completions"];
                } else if (indexPath.row == 1) {
                    [cell.detailTextLabel setText:stats[@"attempts"]];
                    [cell.textLabel setText:@"Pass Attempts"];
                } else if (indexPath.row == 2) {
                    [cell.detailTextLabel setText:stats[@"passYards"]];
                    [cell.textLabel setText:@"Pass Yards"];
                } else if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:stats[@"completionPercentage"]];
                    [cell.textLabel setText:@"Completion Percentage"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:stats[@"yardsPerAttempt"]];
                    [cell.textLabel setText:@"Pass Yards Per Attempt"];
                } else if (indexPath.row == 5) {
                    [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                    [cell.textLabel setText:@"Pass Yards Per Game"];
                } else if (indexPath.row == 6) {
                    [cell.detailTextLabel setText:stats[@"touchdowns"]];
                    [cell.textLabel setText:@"Pass TDs"];
                } else if (indexPath.row == 7) {
                    [cell.detailTextLabel setText:stats[@"interceptions"]];
                    [cell.textLabel setText:@"Interceptions"];
                } else if (indexPath.row == 8) {
                    [cell.detailTextLabel setText:stats[@"carries"]];
                    [cell.textLabel setText:@"Carries"];
                } else if (indexPath.row == 9) {
                    [cell.detailTextLabel setText:stats[@"rushYards"]];
                    [cell.textLabel setText:@"Rush Yards"];
                } else if (indexPath.row == 10) {
                    [cell.detailTextLabel setText:stats[@"yardsPerCarry"]];
                    [cell.textLabel setText:@"Rush Yards Per Carry"];
                } else if (indexPath.row == 11) {
                    [cell.detailTextLabel setText:stats[@"rushYardsPerGame"]];
                    [cell.textLabel setText:@"Rush Yards Per Game"];
                } else if (indexPath.row == 12) {
                    [cell.detailTextLabel setText:stats[@"rushTouchdowns"]];
                    [cell.textLabel setText:@"Rush TDs"];
                } else {
                    [cell.detailTextLabel setText:stats[@"fumbles"]];
                    [cell.textLabel setText:@"Fumbles"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
                if (indexPath.row == 0) {
                    [cell.detailTextLabel setText:stats[@"carries"]];
                    [cell.textLabel setText:@"Carries"];
                } else if (indexPath.row == 1) {
                    [cell.detailTextLabel setText:stats[@"rushYards"]];
                    [cell.textLabel setText:@"Rush Yards"];
                } else if (indexPath.row == 2) {
                    [cell.detailTextLabel setText:stats[@"yardsPerCarry"]];
                    [cell.textLabel setText:@"Yards Per Carry"];
                } else if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                    [cell.textLabel setText:@"Yards Per Game"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:stats[@"touchdowns"]];
                    [cell.textLabel setText:@"Touchdowns"];
                } else {
                    [cell.detailTextLabel setText:stats[@"fumbles"]];
                    [cell.textLabel setText:@"Fumbles"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
                if (indexPath.row == 0) {
                    [cell.detailTextLabel setText:stats[@"catches"]];
                    [cell.textLabel setText:@"Catches"];
                } else if (indexPath.row == 1) {
                    [cell.detailTextLabel setText:stats[@"recYards"]];
                    [cell.textLabel setText:@"Receiving Yards"];
                } else if (indexPath.row == 2) {
                    [cell.detailTextLabel setText:stats[@"yardsPerCatch"]];
                    [cell.textLabel setText:@"Yards Per Catch"];
                } else if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                    [cell.textLabel setText:@"Yards Per Game"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:stats[@"touchdowns"]];
                    [cell.textLabel setText:@"Touchdowns"];
                } else {
                    [cell.detailTextLabel setText:stats[@"fumbles"]];
                    [cell.textLabel setText:@"Fumbles"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerTE class]]) {
                if (indexPath.row == 0) {
                    [cell.detailTextLabel setText:stats[@"catches"]];
                    [cell.textLabel setText:@"Catches"];
                } else if (indexPath.row == 1) {
                    [cell.detailTextLabel setText:stats[@"recYards"]];
                    [cell.textLabel setText:@"Receiving Yards"];
                } else if (indexPath.row == 2) {
                    [cell.detailTextLabel setText:stats[@"yardsPerCatch"]];
                    [cell.textLabel setText:@"Yards Per Catch"];
                } else if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                    [cell.textLabel setText:@"Yards Per Game"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:stats[@"touchdowns"]];
                    [cell.textLabel setText:@"Touchdowns"];
                } else {
                    [cell.detailTextLabel setText:stats[@"fumbles"]];
                    [cell.textLabel setText:@"Fumbles"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
                if (indexPath.row == 0) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"olPower"]];
                    [cell.textLabel setText:@"Strength"];
                } else if (indexPath.row == 1) {
                    //blkP
                    [cell.detailTextLabel setText:ratings[@"olPassBlock"]];
                    [cell.textLabel setText:@"Pass Blocking"];
                } else {
                    //blkR
                    [cell.detailTextLabel setText:ratings[@"olRunBlock"]];
                    [cell.textLabel setText:@"Run Blocking"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerDL class]]) {
                if (indexPath.row == 0) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"dlPow"]];
                    [cell.textLabel setText:@"Strength"];
                } else if (indexPath.row == 1) {
                    //pass
                    [cell.detailTextLabel setText:ratings[@"dlPass"]];
                    [cell.textLabel setText:@"Pass Pressure"];
                } else {
                    //rsh
                    [cell.detailTextLabel setText:ratings[@"dlRun"]];
                    [cell.textLabel setText:@"Run Stopping"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerLB class]]) {
                if (indexPath.row == 0) {
                    //pow
                    [cell.detailTextLabel setText:ratings[@"lbTkl"]];
                    [cell.textLabel setText:@"Tackling"];
                } else if (indexPath.row == 1) {
                    //pass
                    [cell.detailTextLabel setText:ratings[@"lbPass"]];
                    [cell.textLabel setText:@"Pass Pressure"];
                } else {
                    //rsh
                    [cell.detailTextLabel setText:ratings[@"lbRun"]];
                    [cell.textLabel setText:@"Run Stopping"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
                if (indexPath.row == 0) {
                    //cov
                    [cell.detailTextLabel setText:ratings[@"cbCoverage"]];
                    [cell.textLabel setText:@"Coverage Ability"];
                } else if (indexPath.row == 1) {
                    //spd
                    [cell.detailTextLabel setText:ratings[@"cbSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                } else {
                    //tkl
                    [cell.detailTextLabel setText:ratings[@"cbTackling"]];
                    [cell.textLabel setText:@"Tackling Ability"];
                }
            } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
                if (indexPath.row == 0) {
                    //cov
                    [cell.detailTextLabel setText:ratings[@"sCoverage"]];
                    [cell.textLabel setText:@"Coverage Ability"];
                } else if (indexPath.row == 1) {
                    //spd
                    [cell.detailTextLabel setText:ratings[@"sSpeed"]];
                    [cell.textLabel setText:@"Speed"];
                } else {
                    //tkl
                    [cell.detailTextLabel setText:ratings[@"sTackling"]];
                    [cell.textLabel setText:@"Tackling Ability"];
                }
            } else { //Ks
                if (indexPath.row == 0) {
                    [cell.detailTextLabel setText:stats[@"xpMade"]];
                    [cell.textLabel setText:@"XP Made"];
                } else if (indexPath.row == 1) {
                    [cell.detailTextLabel setText:stats[@"xpAtt"]];
                    [cell.textLabel setText:@"XP Attempted"];
                } else if (indexPath.row == 2) {
                    [cell.detailTextLabel setText:stats[@"xpPercentage"]];
                    [cell.textLabel setText:@"XP Percentage"];
                } else if (indexPath.row == 3) {
                    [cell.detailTextLabel setText:stats[@"fgMade"]];
                    [cell.textLabel setText:@"FG Made"];
                } else if (indexPath.row == 4) {
                    [cell.detailTextLabel setText:stats[@"fgAtt"]];
                    [cell.textLabel setText:@"FG Attempted"];
                } else {
                    [cell.detailTextLabel setText:stats[@"fgPercentage"]];
                    [cell.textLabel setText:@"FG Percentage"];
                }
            }
        }
    } else {
        if (indexPath.row == 0) {
            [cell.detailTextLabel setText:careerStats[@"heismans"]];
            [cell.textLabel setText:@"Player of the Year Awards"];
        } else if (indexPath.row == 1) {
            [cell.detailTextLabel setText:careerStats[@"allAmericans"]];
            [cell.textLabel setText:@"All-League Nominations"];
        } else if (indexPath.row == 2) {
            [cell.detailTextLabel setText:careerStats[@"allConferences"]];
            [cell.textLabel setText:@"All-Conference Nominations"];
        } else if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
            if (indexPath.row == 3) {
                [cell.detailTextLabel setText:careerStats[@"completions"]];
                [cell.textLabel setText:@"Completions"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:careerStats[@"attempts"]];
                [cell.textLabel setText:@"Pass Attempts"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:careerStats[@"passYards"]];
                [cell.textLabel setText:@"Pass Yards"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:careerStats[@"completionPercentage"]];
                [cell.textLabel setText:@"Completion Percentage"];
            } else if (indexPath.row == 7) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerAttempt"]];
                [cell.textLabel setText:@"Yards Per Attempt"];
            } else if (indexPath.row == 8) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 9) {
                [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                [cell.textLabel setText:@"Touchdowns"];
            } else if (indexPath.row == 10) {
                [cell.detailTextLabel setText:careerStats[@"interceptions"]];
                [cell.textLabel setText:@"Interceptions"];
            } else if (indexPath.row == 11) {
                [cell.detailTextLabel setText:careerStats[@"carries"]];
                [cell.textLabel setText:@"Carries"];
            } else if (indexPath.row == 12) {
                [cell.detailTextLabel setText:careerStats[@"rushYards"]];
                [cell.textLabel setText:@"Rush Yards"];
            } else if (indexPath.row == 13) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerCarry"]];
                [cell.textLabel setText:@"Rush Yards Per Carry"];
            } else if (indexPath.row == 14) {
                [cell.detailTextLabel setText:careerStats[@"rushYardsPerGame"]];
                [cell.textLabel setText:@"Rush Yards Per Game"];
            } else if (indexPath.row == 15) {
                [cell.detailTextLabel setText:careerStats[@"rushTouchdowns"]];
                [cell.textLabel setText:@"Rush TDs"];
            } else {
                [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                [cell.textLabel setText:@"Fumbles"];
            }
        } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
            if (indexPath.row == 3) {
                [cell.detailTextLabel setText:careerStats[@"carries"]];
                [cell.textLabel setText:@"Carries"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:careerStats[@"rushYards"]];
                [cell.textLabel setText:@"Rush Yards"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerCarry"]];
                [cell.textLabel setText:@"Yards Per Carry"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 7) {
                [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                [cell.textLabel setText:@"Fumbles"];
            }
        } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
            if (indexPath.row == 3) {
                [cell.detailTextLabel setText:careerStats[@"catches"]];
                [cell.textLabel setText:@"Catches"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:careerStats[@"recYards"]];
                [cell.textLabel setText:@"Receiving Yards"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerCatch"]];
                [cell.textLabel setText:@"Yards Per Catch"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 7) {
                [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                [cell.textLabel setText:@"Fumbles"];
            }
        } else if ([selectedPlayer isKindOfClass:[PlayerTE class]]) {
            if (indexPath.row == 3) {
                [cell.detailTextLabel setText:careerStats[@"catches"]];
                [cell.textLabel setText:@"Catches"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:careerStats[@"recYards"]];
                [cell.textLabel setText:@"Receiving Yards"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerCatch"]];
                [cell.textLabel setText:@"Yards Per Catch"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 7) {
                [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                [cell.textLabel setText:@"Fumbles"];
            }
        } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
            if (indexPath.row == 3) {
                //pow
                [cell.detailTextLabel setText:ratings[@"olPower"]];
                [cell.textLabel setText:@"Strength"];
            } else if (indexPath.row == 4) {
                //blkP
                [cell.detailTextLabel setText:ratings[@"olPassBlock"]];
                [cell.textLabel setText:@"Pass Blocking"];
            } else {
                //blkR
                [cell.detailTextLabel setText:ratings[@"olRunBlock"]];
                [cell.textLabel setText:@"Run Blocking"];
            }
        } else if ([selectedPlayer isKindOfClass:[PlayerDL class]]) {
            if (indexPath.row == 3) {
                //pow
                [cell.detailTextLabel setText:ratings[@"dlPow"]];
                [cell.textLabel setText:@"Strength"];
            } else if (indexPath.row == 4) {
                //pass
                [cell.detailTextLabel setText:ratings[@"dlPass"]];
                [cell.textLabel setText:@"Pass Pressure"];
            } else {
                //rsh
                [cell.detailTextLabel setText:ratings[@"dlRun"]];
                [cell.textLabel setText:@"Run Stopping"];
            }
        } else if ([selectedPlayer isKindOfClass:[PlayerLB class]]) {
            if (indexPath.row == 3) {
                //pow
                [cell.detailTextLabel setText:ratings[@"lbTkl"]];
                [cell.textLabel setText:@"Tackling"];
            } else if (indexPath.row == 4) {
                //pass
                [cell.detailTextLabel setText:ratings[@"lbPass"]];
                [cell.textLabel setText:@"Pass Pressure"];
            } else {
                //rsh
                [cell.detailTextLabel setText:ratings[@"lbRun"]];
                [cell.textLabel setText:@"Run Stopping"];
            }
        } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
            if (indexPath.row == 3) {
                //cov
                [cell.detailTextLabel setText:ratings[@"cbCoverage"]];
                [cell.textLabel setText:@"Coverage Ability"];
            } else if (indexPath.row == 4) {
                //spd
                [cell.detailTextLabel setText:ratings[@"cbSpeed"]];
                [cell.textLabel setText:@"Speed"];
            } else {
                //tkl
                [cell.detailTextLabel setText:ratings[@"cbTackling"]];
                [cell.textLabel setText:@"Tackling Ability"];
            }
        } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
            if (indexPath.row == 3) {
                //cov
                [cell.detailTextLabel setText:ratings[@"sCoverage"]];
                [cell.textLabel setText:@"Coverage Ability"];
            } else if (indexPath.row == 4) {
                //spd
                [cell.detailTextLabel setText:ratings[@"sSpeed"]];
                [cell.textLabel setText:@"Speed"];
            } else {
                //tkl
                [cell.detailTextLabel setText:ratings[@"sTackling"]];
                [cell.textLabel setText:@"Tackling Ability"];
            }
        } else { //Ks
            if (indexPath.row == 3) {
                [cell.detailTextLabel setText:careerStats[@"xpMade"]];
                [cell.textLabel setText:@"XP Made"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:careerStats[@"xpAtt"]];
                [cell.textLabel setText:@"XP Attempted"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:careerStats[@"xpPercentage"]];
                [cell.textLabel setText:@"XP Percentage"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:careerStats[@"fgMade"]];
                [cell.textLabel setText:@"FG Made"];
            } else if (indexPath.row == 7) {
                [cell.detailTextLabel setText:careerStats[@"fgAtt"]];
                [cell.textLabel setText:@"FG Attempted"];
            } else {
                [cell.detailTextLabel setText:careerStats[@"fgPercentage"]];
                [cell.textLabel setText:@"FG Percentage"];
            }
        }
    }
    
    if (indexPath.section == 0 && indexPath.row > 2) {
        NSString *stat = cell.detailTextLabel.text;
        
        if (indexPath.section == 0) {
            UIColor *letterColor;   //colors for ratings to tell what's what
            if ([stat containsString:@"A"]) {
                letterColor = [HBSharedUtils successColor];
            } else if ([stat containsString:@"B"]) {
                letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
            } else if ([stat containsString:@"C"]) {
                letterColor = [HBSharedUtils champColor];
            } else if ([stat containsString:@"D"]) {
                letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
            } else {
                letterColor = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
            }
            [cell.detailTextLabel setTextColor:letterColor];
        } else {
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        }
    } else {
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    return cell;
}

@end
