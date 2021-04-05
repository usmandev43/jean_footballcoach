//
//  Player.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"
#import "HBSharedUtils.h"

@implementation Player
@synthesize position,draftPosition,ratDur,personalDetails,endYear,name,team,year,isHeisman,startYear,gamesPlayedSeason,cost,gamesPlayed,hasRedshirt,isAllAmerican,isAllConference,careerAllAmericans,careerAllConferences,ratOvr,ratPot,ratFootIQ,ratImprovement,wasRedshirted,injury,careerHeismans;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
            self.name = [aDecoder decodeObjectForKey:@"name"];
            self.position = [aDecoder decodeObjectForKey:@"position"];
            self.ratOvr = [aDecoder decodeIntForKey:@"ratOvr"];
            self.ratPot = [aDecoder decodeIntForKey:@"ratPot"];
            self.ratImprovement = [aDecoder decodeIntForKey:@"ratImprovement"];
            self.year = [aDecoder decodeIntForKey:@"year"];
            self.ratFootIQ = [aDecoder decodeIntForKey:@"ratFootIQ"];
            self.cost = [aDecoder decodeIntForKey:@"cost"];
            self.gamesPlayed = [aDecoder decodeIntForKey:@"gamesPlayed"];
            self.injury = [aDecoder decodeObjectForKey:@"injury"];
            self.team = [aDecoder decodeObjectForKey:@"team"];
        
        
        if ([aDecoder containsValueForKey:@"stars"]) {
        self.stars = [aDecoder decodeIntForKey:@"stars"];
        } else {
        self.stars = (int) ([HBSharedUtils randomValue] * 5);
        }
        
        
            
    
            if ([aDecoder containsValueForKey:@"draftPosition"]) {
                    self.draftPosition = [aDecoder decodeObjectForKey:@"draftPosition"];
                } else {
                        self.draftPosition = nil;
                    }
    
            if ([aDecoder containsValueForKey:@"hasRedshirt"]) {
                    self.hasRedshirt = [aDecoder decodeBoolForKey:@"hasRedshirt"];
                } else {
                        self.hasRedshirt = NO;
                    }
    
            if ([aDecoder containsValueForKey:@"wasRedshirted"]) {
                    self.wasRedshirted = [aDecoder decodeBoolForKey:@"wasRedshirted"];
                } else {
                        self.wasRedshirted = NO;
                    }
    
            if ([aDecoder containsValueForKey:@"isHeisman"]) {
                    self.isHeisman = [aDecoder decodeBoolForKey:@"isHeisman"];
                } else {
                        self.isHeisman = NO;
                    }
    
            if ([aDecoder containsValueForKey:@"isAllAmerican"]) {
                    self.isAllAmerican = [aDecoder decodeBoolForKey:@"isAllAmerican"];
                } else {
                        self.isAllAmerican = NO;
                    }
    
            if ([aDecoder containsValueForKey:@"isAllConference"]) {
                    self.isAllConference = [aDecoder decodeBoolForKey:@"isAllConference"];
                } else {
                        self.isAllConference = NO;
                    }
    
            if ([aDecoder containsValueForKey:@"ratDur"]) {
                    self.ratDur = [aDecoder decodeIntForKey:@"ratDur"];
                } else {
                        self.ratDur = (int) (50 + 50 * [HBSharedUtils randomValue]);
                    }
    
            if ([aDecoder containsValueForKey:@"careerHeismans"]) {
                    self.careerHeismans = [aDecoder decodeIntForKey:@"careerHeismans"];
                } else {
                        self.careerHeismans = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"careerAllConferences"]) {
                    self.careerAllConferences = [aDecoder decodeIntForKey:@"careerAllConferences"];
                } else {
                        self.careerAllConferences = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"careerAllAmericans"]) {
                    self.careerAllAmericans = [aDecoder decodeIntForKey:@"careerAllAmericans"];
                } else {
                        self.careerAllAmericans = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"endYear"]) {
                    self.endYear = [aDecoder decodeIntForKey:@"endYear"];
                } else {
                        self.endYear = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"gamesPlayedSeason"]) {
                    self.gamesPlayedSeason = [aDecoder decodeIntForKey:@"gamesPlayedSeason"];
                } else {
                        if (self.gamesPlayed > 0) {
                                if (self.team.league.leagueHistoryDictionary.count > 0) {
                                        NSInteger activeYears = self.team.league.leagueHistoryDictionary.count;
                                        self.gamesPlayedSeason = self.gamesPlayed % activeYears;
                                    } else {
                                            self.gamesPlayedSeason = 0;
                                        }
                            } else {
                                    self.gamesPlayedSeason = 0;
                                }
                    }
    
            if ([aDecoder containsValueForKey:@"startYear"]) {
                    int tstStartYr = [aDecoder decodeIntForKey:@"startYear"];
                    if (tstStartYr < 0) {
                            self.startYear = self.endYear - (abs(tstStartYr));
                        } else if (self.endYear != 0 && abs(tstStartYr - self.endYear) > 4) {
                                self.startYear = self.endYear - 4;
                            } else {
                                    self.startYear = [aDecoder decodeIntForKey:@"startYear"];
                                }
                } else {
                        if (self.draftPosition != nil || self.endYear > 0) {
                                //retiree - subtract years from end year
                                self.startYear = (self.endYear - self.year + 1);
                            } else {
                                    //generate
                                    NSInteger curYear = self.team.league.leagueHistoryDictionary.count;
                                    self.startYear = (int)(curYear - self.year + 1) + 2017;
                                }
                    }
        }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.team forKey:@"team"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.position forKey:@"position"];
    [aCoder encodeInt:self.ratOvr forKey:@"ratOvr"];
    [aCoder encodeInt:self.year forKey:@"year"];
    [aCoder encodeInt:self.ratPot forKey:@"ratPot"];
    [aCoder encodeInt:self.ratDur forKey:@"ratDur"];
    [aCoder encodeInt:self.ratFootIQ forKey:@"ratFootIQ"];
    [aCoder encodeInt:self.ratImprovement forKey:@"ratImprovement"];
    [aCoder encodeInt:self.cost forKey:@"cost"];
    [aCoder encodeInt:self.gamesPlayed forKey:@"gamesPlayed"];
    [aCoder encodeInt:self.gamesPlayedSeason forKey:@"gamesPlayedSeason"];
    [aCoder encodeObject:self.injury forKey:@"injury"];
    [aCoder encodeBool:self.wasRedshirted forKey:@"wasRedshirted"];
    [aCoder encodeBool:self.hasRedshirt forKey:@"hasRedshirt"];
    [aCoder encodeBool:self.isHeisman forKey:@"isHeisman"];
    [aCoder encodeBool:self.isAllAmerican forKey:@"isAllAmerican"];
    [aCoder encodeBool:self.isAllConference forKey:@"isAllConference"];
    [aCoder encodeObject:self.draftPosition forKey:@"draftPosition"];
    [aCoder encodeInt:self.careerHeismans forKey:@"careerHeismans"];
    [aCoder encodeInt:self.careerAllConferences forKey:@"careerAllConferences"];
    [aCoder encodeInt:self.careerAllAmericans forKey:@"careerAllAmericans"];
    [aCoder encodeInt:self.startYear forKey:@"startYear"];
    [aCoder encodeInt:self.endYear forKey:@"endYear"];
  
 
    self.stars = (int) ([HBSharedUtils randomValue] * 5);
  
    
    [aCoder encodeInt:self.stars forKey:@"stars"];
}

+(int)getPosNumber:(NSString*)pos {
    if ([pos isEqualToString:@"QB"]) {
        return 0;
    } else if ([pos isEqualToString:@"RB"]) {
        return 1;
    } else if ([pos isEqualToString:@"WR"]) {
        return 2;
    } else if ([pos isEqualToString:@"OL"]) {
        return 3;
    } else if ([pos isEqualToString:@"TE"]) {
        return 4;
    } else if ([pos isEqualToString:@"K"]) {
        return 5;
    } else if ([pos isEqualToString:@"S"]) {
        return 6;
    } else if ([pos isEqualToString:@"CB"]) {
        return 7;
    } else if ([pos isEqualToString:@"DL"]) {
        return 8;
    } else if ([pos isEqualToString:@"LB"]) {
        return 9;
    } else {
        return 10;
    }
}

- (NSComparisonResult)compare:(id)other
{
    Player *player = (Player*)other;
    if (!self.hasRedshirt && !player.hasRedshirt) {
        if (self.ratOvr > player.ratOvr) {
            return -1;
        } else if (self.ratOvr < player.ratOvr) {
            return 1;
        } else {
            if (self.ratPot > player.ratPot) {
                return -1;
            } else if (self.ratPot < player.ratPot) {
                return 1;
            } else {
                return 0;
            }
        }
    } else if (self.hasRedshirt) {
        return 1;
    } else if (player.hasRedshirt) {
        return -1;
    } else {
        if (self.ratOvr > player.ratOvr) {
            return -1;
        } else if (self.ratOvr < player.ratOvr) {
            return 1;
        } else {
            if (self.ratPot > player.ratPot) {
                return -1;
            } else if (self.ratPot < player.ratPot) {
                return 1;
            } else {
                return 0;
            }
        }
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

-(NSString*)getYearString {
    if (self.wasRedshirted || self.hasRedshirt) {
        if (self.year == 0) {
            return @"RS";
        } else if (self.year == 1) {
            return @"RS Fr";
        } else if (self.year == 2) {
            return @"RS So";
        } else if (self.year == 3) {
            return @"RS Jr";
        } else if (self.year == 4) {
            return @"RS Sr";
        } else {
            if (self.draftPosition) {
                return [NSString stringWithFormat:@"Rd%@-Pk%@", self.draftPosition[@"round"],self.draftPosition[@"pick"]];
            } else if (self.draftPosition == nil && self.year > 4) {
                return [NSString stringWithFormat:@"GRAD%ld", (long)self.endYear];
            } else {
                return @"ERROR";
            }
        }
    } else {
        if (self.year == 0) {
            return @"HS";
        } else if (self.year == 1) {
            return @"Fr";
        } else if (self.year == 2) {
            return @"So";
        } else if (self.year == 3) {
            return @"Jr";
        } else if (self.year == 4) {
            return @"Sr";
        } else {
            if (self.draftPosition) {
                return [NSString stringWithFormat:@"Rd%@-Pk%@", self.draftPosition[@"round"],self.draftPosition[@"pick"]];
            } else if (self.draftPosition == nil && self.year > 4) {
                return [NSString stringWithFormat:@"GRAD%ld", (long)self.endYear];
            } else {
                return @"ERROR";
            }
        }
    }
    
    
}

-(NSString*)getFullYearString {
    if (self.wasRedshirted || self.hasRedshirt) {
        if (self.year == 0) {
            return @"Redshirt";
        } else if (self.year == 1) {
            return @"Freshman (RS)";
        } else if (self.year == 2) {
            return @"Sophomore (RS)";
        } else if (self.year == 3) {
            return @"Junior (RS)";
        } else if (self.year == 4) {
            return @"Senior (RS)";
        } else {
            if (self.draftPosition) {
                return [NSString stringWithFormat:@"Round %@, Pick %@", self.draftPosition[@"round"],self.draftPosition[@"pick"]];
            } else if (self.draftPosition == nil && self.year > 4) {
                return [NSString stringWithFormat:@"Graduted in %ld", (long)self.endYear];
            } else {
                return @"ERROR";
            }
        }
    } else {
        if (self.year == 0) {
            return @"High School";
        } else if (self.year == 1) {
            return @"Freshman";
        } else if (self.year == 2) {
            return @"Sophomore";
        } else if (self.year == 3) {
            return @"Junior";
        } else if (self.year == 4) {
            return @"Senior";
        } else {
            if (self.draftPosition) {
                return [NSString stringWithFormat:@"Round %@, Pick %@", self.draftPosition[@"round"],self.draftPosition[@"pick"]];
            } else if (self.draftPosition == nil && self.year > 4) {
                return [NSString stringWithFormat:@"Graduted in %ld", (long)self.endYear];
            } else {
                return @"ERROR";
            }
        }
    }
}

-(BOOL)isInjured {
    return (self.injury != nil);
}

-(void)advanceSeason {
    self.year++;
    self.gamesPlayedSeason = 0;
    self.isHeisman = NO;
    self.isAllAmerican = NO;
    self.isAllConference = NO;
    self.injury = nil;
    if (self.hasRedshirt) {
        self.hasRedshirt = NO;
        self.wasRedshirted = YES;
    }
}

-(int)getHeismanScore {
    int adjGames = self.gamesPlayed;
    if (adjGames > 10) adjGames = 10;
    return self.ratOvr * adjGames;
}

-(NSString*)getInitialName {
    NSArray *names = [self.name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstName = names[0];
    return [NSString stringWithFormat:@"%@. %@", [firstName substringWithRange:NSMakeRange(0, 1)], names[1]];
}

-(NSString*)getPosNameYrOvrPot_Str {
    return [NSString stringWithFormat:@"%@ %@ [%@] (OVR: %ld)\n", self.position, self.name, [self getYearString], (long)self.ratOvr];
}

-(NSString*)getPosNameYrOvrPot_OneLine {
    return [NSString stringWithFormat:@"%@ %@ [%@] (OVR: %ld)\n", self.position, [self getInitialName], [self getYearString], (long)self.ratOvr];
}

-(NSString*)getLetterGradeWithString:(NSString*)num {
    int ind = ([num intValue] - 50)/5;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGradePotWithString:(NSString*)num {
    int ind = ([num intValue]) / 10;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGrade:(int)num {
    int ind = (num - 50)/5;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGradePot:(int)num {
    int ind = num / 10;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSDictionary*)detailedStats:(int)games {
    return [NSDictionary dictionary];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerAllConferences] forKey:@"allConferences"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerAllAmericans] forKey:@"allAmericans"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerHeismans] forKey:@"heismans"];
    return stats;
}

-(NSDictionary*)detailedRatings {
    return @{@"potential" : [self getLetterGrade:self.ratPot], @"durability" : [self getLetterGrade:self.ratDur]};
}

-(void)checkRecords {
    
}

-(NSString *)simpleAwardReport {
    NSMutableString *awards = [NSMutableString string];
    int parts = 0;
    if (self.careerHeismans > 0) {
        [awards appendFormat:@"%lix POTY",(long)self.careerHeismans];
        parts++;
    }
    
    if (self.careerAllAmericans > 0) {
        [awards appendFormat:@"?%lix All-League",(long)self.careerAllAmericans];
        parts++;
    }
    
    if (self.careerAllConferences > 0) {
        [awards appendFormat:@"?%lix All-Conference",(long)self.careerAllConferences];
        parts++;
    }
    
    if (parts > 1) {
        [awards replaceOccurrencesOfString:@"?" withString:@", " options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    } else {
        [awards replaceOccurrencesOfString:@"?" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    }
    
    
    
    awards = [NSMutableString stringWithString:[[awards stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return awards;
}
@end
