//
//  Player.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Injury.h"
#import "HBSharedUtils.h"

@interface Player : NSObject <NSCoding> {
    BOOL isDraftEligible; //deprecated
}

@property (strong, nonatomic) Team *team;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSDictionary *personalDetails; // { "height" : "6\'2\"", "weight" : "235 lbs", "home_state" : "Hawaii" };
@property (nonatomic) int ratOvr;
@property (nonatomic) int year;
@property (nonatomic) int stars;
@property (nonatomic) int ratPot;
@property (nonatomic) int ratFootIQ;
@property (nonatomic) int ratImprovement;
@property (nonatomic) int ratDur;
@property (nonatomic) int cost;
@property (nonatomic) int gamesPlayedSeason;
@property (nonatomic) int gamesPlayed;
@property (nonatomic) BOOL hasRedshirt;
@property (nonatomic) BOOL wasRedshirted;
@property (nonatomic) BOOL isHeisman;
@property (nonatomic) BOOL isAllAmerican;
@property (nonatomic) BOOL isAllConference;
@property (strong, nonatomic) Injury *injury;
@property (strong, nonatomic) NSDictionary *draftPosition; // { "round" : "1", @"pick" : "32" }
@property (nonatomic) int careerHeismans;
@property (nonatomic) int careerAllAmericans;
@property (nonatomic) int careerAllConferences;
@property (nonatomic) int startYear;
@property (nonatomic) int endYear;

-(BOOL)isInjured;
-(NSString *)simpleAwardReport;
+(NSArray *)letterGrades;
-(NSString*)getYearString;
-(NSString*)getFullYearString;
-(void)advanceSeason;
-(int)getHeismanScore;
-(NSString*)getInitialName;
-(NSString*)getPosNameYrOvrPot_Str;
-(NSString*)getPosNameYrOvrPot_OneLine;
-(NSString*)getLetterGradeWithString:(NSString*)num;
-(NSString*)getLetterGradePotWithString:(NSString*)num;
-(NSString*)getLetterGrade:(int)num;
-(NSString*)getLetterGradePot:(int)num;
-(NSDictionary*)detailedStats:(int)games;
-(NSDictionary*)detailedCareerStats;
-(NSDictionary*)detailedRatings;
-(void)checkRecords;
+(int)getPosNumber:(NSString*)pos;
@end
