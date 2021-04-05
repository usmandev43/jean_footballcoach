//
//  HBSharedUtils.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "HBSharedUtils.h"
#import "AppDelegate.h"
#import "League.h"
#import "Team.h"
#import "Player.h"
#import "HBTeamPlayView.h"

#import "CSNotificationView.h"
#import "HexColors.h"

#import "MockDraftViewController.h"
#import "RecruitingViewController.h"
#import "GraduatingPlayersViewController.h"
#import "NSBundle+ENTALDNSBundle.h"

#define ARC4RANDOM_MAX      0x100000000
static UIColor *styleColor = nil;

@implementation HBSharedUtils

+(double)randomValue {
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

+(League*)getLeague {
    League *ligue = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) league];
    ligue.userTeam.isUserControlled = YES;
    return ligue;
}

+(int)leagueRecruitingStage {
    return [HBSharedUtils getLeague].recruitingStage;
}

+(UIColor *)styleColor { //FC Android color: #3EB49F or #3DB39E //FC iOS color: #009740 //USA Red: #BB133E // USA Blue: #002147
//    return [UIColor hx_colorWithHexRGBAString:@"#3DB39E"];
    return [UIColor hx_colorWithHexRGBAString:@"#053c72"];
}

+(UIColor *)orrangeColor {
    return [UIColor hx_colorWithHexRGBAString:@"#E0623B"];
}
+(UIColor *)errorColor {
    return [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
}

+(UIColor *)successColor {
    return [UIColor hx_colorWithHexRGBAString:@"#1a9641"];
}

+(UIColor *)champColor {
    return [UIColor hx_colorWithHexRGBAString:@"#eeb211"];
}
+(UIColor *)hireColor {
    return [UIColor hx_colorWithHexRGBAString:@"#31521D"];
}
//
+(void)setStyleColor:(NSDictionary*)colorDict {
    styleColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorDict[@"color"]];
    [[NSUserDefaults standardUserDefaults] setObject:colorDict forKey:HB_CURRENT_THEME_COLOR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
     [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setupAppearance];
    
}

+(NSArray*)colorOptions { //FC Android color: #3EB49F //FC iOS color: #009740 //USA Red: #BB133E // USA Blue: #002147
    return @[
  @{@"title" : @"Android Default", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#3EB49F"]]},
  @{@"title" : @"iOS Default", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#009740"]]},
  @{@"title" : @"Old Glory Blue", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#002147"]]},
  @{@"title" : @"Old Glory Red", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#BB133E"]]}
             ];
}

+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController {
    BOOL weekNotifs = [[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
    if (weekNotifs) {
        [CSNotificationView showInViewController:viewController tintColor:tintColor image:nil message:message duration:0.75];
    }
}

+ (NSArray *)states {
    static dispatch_once_t onceToken;
    static NSArray *states;
    dispatch_once(&onceToken, ^{
        states = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    });
    return states;
}

+ (NSString *)randomState {
    int index = [[self class] randomValue] * 50;
    return [[self class] states][index];
}

+(NSComparisonResult)comparePlayers:(id)obj1 toObj2:(id)obj2 {
    Player *a = (Player*)obj1;
    Player *b = (Player*)obj2;
    if (![a isInjured] && [b isInjured]) {
        return -1;
    } else if ([a isInjured] && ![b isInjured]) {
        return  1;
    } else {
        return a.ratOvr > b.ratOvr ? -1 : (a.ratOvr == b.ratOvr ? 0 : 1);
    }
}

+(NSComparisonResult)comparePositions:(id)obj1 toObj2:(id)obj2 {
    Player *a = (Player*)obj1;
    Player *b = (Player*)obj2;
    int aPos = [Player getPosNumber:a.position];
    int bPos = [Player getPosNumber:b.position];
    return aPos < bPos ? -1 : aPos == bPos ? 0 : 1;
}

+(NSComparisonResult)compareDivTeams:(id)obj1 toObj2:(id)obj2
{
    return [HBSharedUtils comparePlayoffTeams:obj1 toObj2:obj2];
}

+(NSComparisonResult)comparePlayoffTeams:(id)obj1 toObj2:(id)obj2
{
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    int aDivW = [a calculateConfWins];
    int bDivW = [b calculateConfWins];
    
    if ([a.confChampion isEqualToString:@"CC"] && ![b.confChampion isEqualToString:@"CC"])
        return -1;
    else if ([b.confChampion isEqualToString:@"CC"] && ![a.confChampion isEqualToString:@"CC"])
        return 1;
    else if (a.wins > b.wins) {
        return -1;
    } else if (a.wins < b.wins) {
        return 1;
    } else { // wins equal, check head to head
        if (![b.gameWinsAgainst containsObject:a]) {
            // b never won against a
            return -1;
        } else if (![a.gameWinsAgainst containsObject:b]) {
            // a never won against b
            return 1;
        } else { //they both beat each other at least once, check poll score, which will tie break with ppg if necessary
            if (aDivW > bDivW) {
                return -1;
            } else if (bDivW > aDivW) {
                return 1;
            } else {
                return [HBSharedUtils comparePollScore:a toObj2:b];
            }
        }
    }
}

+(NSComparisonResult)compareMVPScore:(id)obj1 toObj2:(id)obj2 {
    Player *a = (Player*)obj1;
    Player *b = (Player*)obj2;
    return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
}

+(NSComparisonResult)comparePollScore:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? (a.wins > b.wins ? -1 : a.wins == b.wins ? ([[self class] compareTeamPPG:a toObj2:b]) : 1) : 1;
}

+(NSComparisonResult)compareSoW:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamStrengthOfWins > b.teamStrengthOfWins ? -1 : a.teamStrengthOfWins == b.teamStrengthOfWins ? 0 : 1;
}

+(NSComparisonResult)compareTeamPPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamPoints/[a numGames] > b.teamPoints/[b numGames] ? -1 : a.teamPoints/[a numGames] == b.teamPoints/[b numGames] ? 0 : 1;
}
+(NSComparisonResult)compareOppPPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOppPoints/[a numGames] < b.teamOppPoints/[b numGames] ? -1 : a.teamOppPoints/[a numGames] == b.teamOppPoints/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareTeamYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamYards/[a numGames] > b.teamYards/[b numGames] ? -1 : a.teamYards/[a numGames] == b.teamYards/[b numGames] ? 0 : 1;
}
+(NSComparisonResult)compareOppYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOppYards/[a numGames] < b.teamOppYards/[b numGames] ? -1 : a.teamOppYards/[a numGames] == b.teamOppYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareOppPYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOppPassYards/[a numGames] < b.teamOppPassYards/[b numGames] ? -1 : a.teamOppPassYards/[a numGames] == b.teamOppPassYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareOppRYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOppRushYards/[a numGames] < b.teamOppRushYards/[b numGames] ? -1 : a.teamOppRushYards/[a numGames] == b.teamOppRushYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareTeamPYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamPassYards/[a numGames] > b.teamPassYards/[b numGames] ? -1 : a.teamPassYards/[a numGames] == b.teamPassYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareTeamRYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamRushYards/[a numGames] > b.teamRushYards/[b numGames] ? -1 : a.teamRushYards/[a numGames] == b.teamRushYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareTeamTODiff:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamTODiff > b.teamTODiff ? -1 : a.teamTODiff == b.teamTODiff ? 0 : 1;
}

+(NSComparisonResult)compareTeamOffTalent:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOffTalent > b.teamOffTalent ? -1 : a.teamOffTalent == b.teamOffTalent ? 0 : 1;
}

+(NSComparisonResult)compareTeamDefTalent:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamDefTalent > b.teamDefTalent ? -1 : a.teamDefTalent == b.teamDefTalent ? 0 : 1;
}

+(NSComparisonResult)compareTeamPrestige:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamPrestige > b.teamPrestige ? -1 : a.teamPrestige == b.teamPrestige ? 0 : 1;
}

+(NSComparisonResult)compareTeamLeastWins:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.wins < b.wins ? -1 : a.wins == b.wins ? 0 : 1;
}

+ (void)startOffseason:(UIViewController*)viewController callback:(void (^)(void))callback {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld %@ Offseason", (long)([HBSharedUtils getLeague].leagueHistoryDictionary.count + [HBSharedUtils getLeague].baseYear), [HBSharedUtils getLeague].userTeam.abbreviation] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"View Players Leaving" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [viewController.navigationController pushViewController:[[GraduatingPlayersViewController alloc] init] animated:YES];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Start Recruiting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_OFFSEASON_TUTORIAL_SHOWN_KEY];
        if (!tutorialShown) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_OFFSEASON_TUTORIAL_SHOWN_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //display intro screen
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController *tutorialAlert = [UIAlertController alertControllerWithTitle:@"Offseason Warning" message:@"Once you start the offseason, it is recommended that you do not quit or leave the game until you complete the draft and move on to the next season. Doing so may result in the corruption of your save file. Are you sure you wish to continue?" preferredStyle:UIAlertControllerStyleAlert];
                [tutorialAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[HBSharedUtils getLeague] updateTeamHistories];
                    [[HBSharedUtils getLeague] updateLeagueHistory];
                    [[HBSharedUtils getLeague].userTeam resetStats];
                    [[HBSharedUtils getLeague] advanceSeason];
                    [[HBSharedUtils getLeague] save];
                    [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]] animated:YES completion:nil];
                }]];
                [tutorialAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
                [viewController presentViewController:tutorialAlert animated:YES completion:nil];
            });
        } else {
            [[HBSharedUtils getLeague] updateTeamHistories];
            [[HBSharedUtils getLeague] updateLeagueHistory];
            [[HBSharedUtils getLeague].userTeam resetStats];
            [[HBSharedUtils getLeague] advanceSeason];
            [[HBSharedUtils getLeague] save];
            [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]] animated:YES completion:nil];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"View Mock Draft" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MockDraftViewController alloc] init]] animated:YES completion:nil];
        });
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

+(void)playWeek:(UIViewController*)viewController headerView:(HBTeamPlayView*)teamHeaderView callback:(void (^)(void))callback {
    League *simLeague = [HBSharedUtils getLeague];
    
    if (simLeague.recruitingStage == 0) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 1;
            [HBSharedUtils getLeague].canRebrandTeam = YES;
            [HBSharedUtils startOffseason:viewController callback:nil];
        } else {
            NSInteger numGamesPlayed = simLeague.userTeam.gameWLSchedule.count;
            [simLeague playWeek];
            [[HBSharedUtils getLeague] save];
            if (simLeague.currentWeek == 15) {
                // Show NCG summary
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)([HBSharedUtils getLeague].baseYear + simLeague.userTeam.teamHistoryDictionary.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
                
                
            } else if (simLeague.userTeam.gameWLSchedule.count > numGamesPlayed) {
                // Played a game, show summary - show notification
                if (simLeague.currentWeek <= 12) {
                    NSString *gameSummary = [simLeague.userTeam weekSummaryString];
                    if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"Week %ld: %@", (long)simLeague.currentWeek, [simLeague.userTeam weekSummaryString]] onViewController:viewController];
                    } else {
                        [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"Week %ld: %@", (long)simLeague.currentWeek, [simLeague.userTeam weekSummaryString]] onViewController:viewController];
                    }
                } else {
                    if (simLeague.currentWeek == 15) {
                        [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
                        NSString *gameSummary = [simLeague.userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"NCG - %@",[simLeague.userTeam weekSummaryString]] onViewController:viewController];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"NCG - %@",[simLeague.userTeam weekSummaryString]] onViewController:viewController];
                        }
                    } else if (simLeague.currentWeek == 14) {
                        NSString *gameSummary = [simLeague.userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"Bowls: %@", [simLeague.userTeam weekSummaryString]] onViewController:viewController];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"Bowls: %@", [simLeague.userTeam weekSummaryString]] onViewController:viewController];
                        }
                    } else if (simLeague.currentWeek == 13) {
                        NSString *gameSummary = [simLeague.userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"%@ CCG: %@", simLeague.userTeam.conference, [simLeague.userTeam weekSummaryString]] onViewController:viewController];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"%@ CCG: %@",simLeague.userTeam.conference, [simLeague.userTeam weekSummaryString]] onViewController:viewController];
                        }
                    }
                }
                
            }
            
            if (simLeague.currentWeek >= 12) {
                if (simLeague.userTeam.gameSchedule.count > 0) {
                    Game *nextGame = [simLeague.userTeam.gameSchedule lastObject];
                    if (!nextGame.hasPlayed) {
                        NSString *weekGameName = nextGame.gameName;
                        if ([weekGameName isEqualToString:@"NCG"]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"%@ was invited to the National Championship Game!",simLeague.userTeam.name] onViewController:viewController];
                            });
                        } else {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"%@ was invited to the %@!",simLeague.userTeam.name, weekGameName] onViewController:viewController];
                            });
                        }
                    } else if (simLeague.currentWeek == 12) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"%@ was not invited to the %@ CCG.",simLeague.userTeam.name,simLeague.userTeam.conference] onViewController:viewController];
                        });
                    } else if (simLeague.currentWeek == 13) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"%@ was not invited to a bowl game.",simLeague.userTeam.name] onViewController:viewController];
                        });
                    }
                }
            }
            
            if (simLeague.currentWeek < 12) {
                [HBSharedUtils getLeague].canRebrandTeam = NO;
                [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
                [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON] && simLeague.userTeam.league.currentWeek != 15 && simLeague.userTeam.injuredPlayers.count > 0 && simLeague.userTeam.league.isHardMode) {
                    NSString *injuryReport = [simLeague.userTeam injuryReport];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Injury Report", simLeague.userTeam.abbreviation] message:injuryReport preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
                    });
                }
                
            } else if (simLeague.currentWeek == 12) {
                [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 13) {
                NSString *heismanString = [simLeague getHeismanCeremonyStr];
                NSArray *heismanParts = [heismanString componentsSeparatedByString:@"?"];
                NSMutableString *composeHeis = [NSMutableString string];
                for (int i = 1; i < heismanParts.count; i++) {
                    [composeHeis appendString:heismanParts[i]];
                }
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld's Player of the Year", (long)([HBSharedUtils getLeague].baseYear + simLeague.userTeam.teamHistoryDictionary.count)] message:composeHeis preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
                
                [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 14) {
                [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
            } else {
                [HBSharedUtils getLeague].canRebrandTeam = YES;
                [teamHeaderView.playButton setEnabled:YES];
                [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
                [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSimButton" object:nil];
            }
            
            callback();
        }
    } else {
        simLeague.recruitingStage = 1;
        [HBSharedUtils startOffseason:viewController callback:nil];
    }
}

+(CGFloat)getScreenWidth{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width;
}

+ (CoachesCommonModel * _Nullable)getCoachesData {
    NSDictionary *dict = [NSBundle loadAFJsonDictionaryWithFileName:@"coachDBjson"];
    if (dict != nil) {
        return [self modelObjectFromDictionary:dict];
    }
    
    return nil;
}

+(CoachesCommonModel * _Nullable)modelObjectFromDictionary:(NSDictionary *)dict {
    NSError *error;
    CoachesCommonModel *model = [[CoachesCommonModel alloc] initWithDictionary:dict error:&error];
     NSLog(@"Dataset %@",dict[@"data"]);
    return model;
}

+(void)simulateEntireSeason:(int)weekTotal viewController:(UIViewController *)viewController headerView:(HBTeamPlayView *)teamHeaderView callback:(void (^)(void))callback {
    League *simLeague = [HBSharedUtils getLeague];
    [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
    [teamHeaderView.playButton setEnabled:NO];
    if (simLeague.recruitingStage == 0) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 1;
            [HBSharedUtils getLeague].canRebrandTeam = YES;
            [[HBSharedUtils getLeague] save];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)([HBSharedUtils getLeague].baseYear + simLeague.userTeam.teamHistoryDictionary.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
        } else {
            float simTime = 0.5;
            if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
                simTime = 1.5;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(simTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [simLeague playWeek];
                
                if (simLeague.currentWeek < 12) {
                    [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
                    [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 12) {
                    NSString *heisman = [simLeague getHeismanCeremonyStr];
                    NSLog(@"HEISMAN: %@", heisman); //can't do anything with this result, just want to run it tbh
                    [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 13) {
                    [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 14) {
                    [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
                } else {
                    [HBSharedUtils getLeague].canRebrandTeam = YES;
                    simLeague.recruitingStage = 1;
                    [((HBTeamPlayView*)teamHeaderView).playButton setEnabled:YES];
                    [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
                    [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSimButton" object:nil];
                }
                
                callback();
                if (weekTotal > 1 && simLeague.currentWeek < 15) {
                    NSLog(@"WEEK TOTAL: %d",weekTotal);
                    [[self class] simulateEntireSeason:(weekTotal - 1) viewController:viewController headerView:teamHeaderView callback:callback];
                } else {
                    NSLog(@"NO WEEKS LEFT");
                    if (simLeague.currentWeek > 14) {
                       [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
                    } else {
                        [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
                        [((HBTeamPlayView*)teamHeaderView).playButton setEnabled:YES];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"injuriesPosted" object:nil];
                    [[HBSharedUtils getLeague] save];
                }
            });
        }
    } else {
        [HBSharedUtils startOffseason:viewController callback:nil];
    }
}


+ (NSArray *)letterGrades
{
    static NSArray *letterGrades;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        letterGrades = @[@"F", @"F+", @"D", @"D+", @"C", @"C+", @"B", @"B+", @"A", @"A+"];

    });
    return letterGrades;
}

+(NSString*)getLetterGrade:(int)num {
    int ind = (num - 50)/5;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}




@end
