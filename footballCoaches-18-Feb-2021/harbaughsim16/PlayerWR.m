//
//  PlayerWR.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerWR.h"
#import "Team.h"
#import "Record.h"
#import "League.h"

@implementation PlayerWR
@synthesize  ratRecCat,ratRecEva,ratRecSpd,statsFumbles,statsTD,statsDrops,statsTargets,careerStatsTD,careerStatsTargets,careerStatsFumbles,careerStatsDrops,careerStatsRecYards,statsRecYards,statsReceptions,careerStatsReceptions;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
            self.ratRecCat = [aDecoder decodeIntForKey:@"ratRecCat"];
            self.ratRecSpd = [aDecoder decodeIntForKey:@"ratRecSpd"];
            self.ratRecEva = [aDecoder decodeIntForKey:@"ratRecEva"];
            self.statsTargets = [aDecoder decodeIntForKey:@"statsTargets"];
            self.statsReceptions = [aDecoder decodeIntForKey:@"statsReceptions"];
            self.statsDrops = [aDecoder decodeIntForKey:@"statsDrops"];
            self.statsTD = [aDecoder decodeIntForKey:@"statsTD"];
            self.statsFumbles = [aDecoder decodeIntForKey:@"statsFumbles"];
            self.statsRecYards = [aDecoder decodeIntForKey:@"statsRecYards"];
    
    
            if ([aDecoder containsValueForKey:@"careerStatsRecYards"]) {
                    self.careerStatsRecYards = [aDecoder decodeIntForKey:@"careerStatsRecYards"];
                } else {
                        self.careerStatsRecYards = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"careerStatsReceptions"]) {
                    self.careerStatsReceptions = [aDecoder decodeIntForKey:@"careerStatsReceptions"];
                } else {
                        self.careerStatsReceptions = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"careerStatsTD"]) {
                    self.careerStatsTD = [aDecoder decodeIntForKey:@"careerStatsTD"];
                } else {
                        self.careerStatsTD = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"careerStatsTargets"]) {
                    self.careerStatsTargets = [aDecoder decodeIntForKey:@"careerStatsTargets"];
                } else {
                        self.careerStatsTargets = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"careerStatsFumbles"]) {
                    self.careerStatsFumbles = [aDecoder decodeIntForKey:@"careerStatsFumbles"];
                } else {
                        self.careerStatsFumbles = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"careerStatsDrops"]) {
                    self.careerStatsDrops = [aDecoder decodeIntForKey:@"careerStatsDrops"];
                } else {
                        self.careerStatsDrops = 0;
                    }
    
            if ([aDecoder containsValueForKey:@"personalDetails"]) {
                    self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
                    if (self.personalDetails == nil) {
                            NSInteger weight = (int)([HBSharedUtils randomValue] * 45) + 195;
                            NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 1;
                            self.personalDetails = @{
                                                                                               @"home_state" : [HBSharedUtils randomState],
                                                                                                                                         @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                                                                                                                         @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                                                                                                                         };
                        }
                } else {
                        NSInteger weight = (int)([HBSharedUtils randomValue] * 45) + 195;
                        NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 1;
                        self.personalDetails = @{
                                                                                       @"home_state" : [HBSharedUtils randomState],
                                                                                                                             @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                                                                                                             @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                                                                                                             };
                    }
        }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    [aCoder encodeInt:self.ratRecCat forKey:@"ratRecCat"];
    [aCoder encodeInt:self.ratRecSpd forKey:@"ratRecSpd"];
    [aCoder encodeInt:self.ratRecEva forKey:@"ratRecEva"];

    [aCoder encodeInt:self.statsRecYards forKey:@"statsRecYards"];
    [aCoder encodeInt:self.statsFumbles forKey:@"statsFumbles"];
    [aCoder encodeInt:self.statsTD forKey:@"statsTD"];
    [aCoder encodeInt:self.statsReceptions forKey:@"statsReceptions"];
    [aCoder encodeInt:self.statsDrops forKey:@"statsDrops"];
    [aCoder encodeInt:self.statsTargets forKey:@"statsTargets"];

    [aCoder encodeInt:self.careerStatsRecYards forKey:@"careerStatsRecYards"];
    [aCoder encodeInt:self.careerStatsReceptions forKey:@"careerStatsReceptions"];
    [aCoder encodeInt:self.careerStatsTD forKey:@"careerStatsTD"];
    [aCoder encodeInt:self.careerStatsTargets forKey:@"careerStatsTargets"];
    [aCoder encodeInt:self.careerStatsFumbles forKey:@"careerStatsFumbles"];
    [aCoder encodeInt:self.careerStatsDrops forKey:@"careerStatsDrops"];

    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq catch:(int)cat speed:(int)spd eva:(int)eva dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.ratDur = dur;
        self.year = yr;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + (int)t.league.baseYear;
        self.ratOvr = (cat*2 + spd + eva)/4;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        self.ratRecCat = cat;
        self.ratRecSpd = spd;
        self.ratRecEva = eva;
        
        self.cost = (int)(powf((float)self.ratOvr/5,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 45) + 195;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 1;
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        
        self.statsReceptions = 0;
        self.statsRecYards = 0;
        self.statsTargets = 0;
        self.statsDrops = 0;
        self.statsFumbles = 0;
        self.statsTD = 0;
        self.statsFumbles = 0;
        
        self.careerStatsReceptions = 0;
        self.careerStatsRecYards = 0;
        self.careerStatsTargets = 0;
        self.careerStatsDrops = 0;
        self.careerStatsFumbles = 0;
        self.careerStatsTD = 0;
        self.careerStatsFumbles = 0;
        
        self.position = @"WR";
    }
    return self;
}

-(instancetype)initWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    self = [super init];
    if (self) {
        self.name = nm;
        self.year = yr;
        self.team = t;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + (int)t.league.baseYear;
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratRecCat = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratRecSpd = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratRecEva = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratRecCat*2 + self.ratRecSpd + self.ratRecEva)/4;
        
        self.cost = (int)pow((float)self.ratOvr/5,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 45) + 195;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 1;
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        
        self.careerStatsReceptions = 0;
        self.careerStatsRecYards = 0;
        self.careerStatsTargets = 0;
        self.careerStatsDrops = 0;
        self.careerStatsFumbles = 0;
        self.careerStatsTD = 0;
        self.careerStatsFumbles = 0;
        
        self.statsTargets = 0;
        self.statsReceptions = 0;
        self.statsRecYards = 0;
        self.statsTD = 0;
        self.statsDrops = 0;
        self.statsFumbles = 0;
        
        self.position = @"WR";
    }
    return self;
}

+(instancetype)newWRWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq catch:(int)cat speed:(int)spd eva:(int)eva dur:(int)dur {
    return [[PlayerWR alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq catch:cat speed:spd eva:eva dur:dur];
}

+(instancetype)newWRWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerWR alloc] initWithName:nm year:yr stars:stars team:t];
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    self.ratOvr = (self.ratRecCat*2 + self.ratRecSpd + self.ratRecEva)/4;
    self.ratImprovement = self.ratOvr - oldOvr;
    
    self.statsTargets = 0;
    self.statsReceptions = 0;
    self.statsRecYards = 0;
    self.statsTD = 0;
    self.statsDrops = 0;
    self.statsFumbles = 0;
    [super advanceSeason];
}

-(int)getHeismanScore {
    return self.statsTD * 150 - self.statsFumbles * 100 - self.statsDrops * 50 + self.statsRecYards * 2;
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d TDs",self.statsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.statsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d catches",self.statsReceptions] forKey:@"catches"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",self.statsRecYards] forKey:@"recYards"];
    
    int ypc = 0;
    if (self.statsReceptions > 0) {
        ypc = (int)ceil((double)self.statsRecYards/(double)self.statsReceptions);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/catch",ypc] forKey:@"yardsPerCatch"];
    
    int ypg = 0;
    if (games > 0) {
        ypg = (int)ceil((double)self.statsRecYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedCareerStats]];
    [stats setObject:[NSString stringWithFormat:@"%d TDs",self.careerStatsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.careerStatsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d catches",self.careerStatsReceptions] forKey:@"catches"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",self.careerStatsRecYards] forKey:@"recYards"];
    
    int ypc = 0;
    if (self.careerStatsReceptions > 0) {
        ypc = (int)((double)self.careerStatsRecYards/(double)self.careerStatsReceptions);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/catch",ypc] forKey:@"yardsPerCatch"];
    
    int ypg = 0;
    if (self.gamesPlayed > 0) {
        ypg = (int)((double)self.careerStatsRecYards/(double)self.gamesPlayed);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:self.ratRecCat] forKey:@"recCatch"];
    [stats setObject:[self getLetterGrade:self.ratRecSpd] forKey:@"recSpeed"];
    [stats setObject:[self getLetterGrade:self.ratRecEva] forKey:@"recEvasion"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

-(void)checkRecords {
    //Catches
    if (self.statsReceptions > self.team.singleSeasonCatchesRecord.statistic) {
        self.team.singleSeasonCatchesRecord = [Record newRecord:@"Catches" player:self stat:self.statsReceptions year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsReceptions > self.team.careerCatchesRecord.statistic) {
        self.team.careerCatchesRecord = [Record newRecord:@"Catches" player:self stat:self.careerStatsReceptions year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsReceptions > self.team.league.singleSeasonCatchesRecord.statistic) {
        self.team.league.singleSeasonCatchesRecord = [Record newRecord:@"Catches" player:self stat:self.statsReceptions year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsReceptions > self.team.league.careerCatchesRecord.statistic) {
        self.team.league.careerCatchesRecord = [Record newRecord:@"Catches" player:self stat:self.careerStatsReceptions year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //TD
    if (self.statsTD > self.team.singleSeasonRecTDsRecord.statistic) {
        self.team.singleSeasonRecTDsRecord = [Record newRecord:@"Rec TDs" player:self stat:self.statsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsTD > self.team.careerRecTDsRecord.statistic) {
        self.team.careerRecTDsRecord = [Record newRecord:@"Rec TDs" player:self stat:self.careerStatsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsTD > self.team.league.singleSeasonRecTDsRecord.statistic) {
        self.team.league.singleSeasonRecTDsRecord = [Record newRecord:@"Rec TDs" player:self stat:self.statsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsTD > self.team.league.careerRecTDsRecord.statistic) {
        self.team.league.careerRecTDsRecord = [Record newRecord:@"Rec TDs" player:self stat:self.careerStatsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //Rec Yards
    if (self.statsRecYards > self.team.singleSeasonRecYardsRecord.statistic) {
        self.team.singleSeasonRecYardsRecord = [Record newRecord:@"Rec Yards" player:self stat:self.statsRecYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsRecYards > self.team.careerRecYardsRecord.statistic) {
        self.team.careerRecYardsRecord = [Record newRecord:@"Rec Yards" player:self stat:self.careerStatsRecYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsRecYards > self.team.league.singleSeasonRecYardsRecord.statistic) {
        self.team.league.singleSeasonRecYardsRecord = [Record newRecord:@"Rec Yards" player:self stat:self.statsRecYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsRecYards > self.team.league.careerRecYardsRecord.statistic) {
        self.team.league.careerRecYardsRecord = [Record newRecord:@"Rec Yards" player:self stat:self.careerStatsRecYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //Fumbles
    if (self.statsFumbles > self.team.singleSeasonFumblesRecord.statistic) {
        self.team.singleSeasonFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.statsFumbles year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsFumbles > self.team.careerFumblesRecord.statistic) {
        self.team.careerFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.careerStatsFumbles year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsFumbles > self.team.league.singleSeasonFumblesRecord.statistic) {
        self.team.league.singleSeasonFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.statsFumbles year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsFumbles > self.team.league.careerFumblesRecord.statistic) {
        self.team.league.careerFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.careerStatsFumbles year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
}

@end
