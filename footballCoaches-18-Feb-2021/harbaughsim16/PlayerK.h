//
//  PlayerK.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerK : Player <NSCoding>
@property (nonatomic) int ratKickPow;
@property (nonatomic) int ratKickAcc;
@property (nonatomic) int ratKickFum;
@property (nonatomic) int statsXPAtt;
@property (nonatomic) int statsXPMade;
@property (nonatomic) int statsFGAtt;
@property (nonatomic) int statsFGMade;

@property (nonatomic) int careerStatsXPAtt;
@property (nonatomic) int careerStatsXPMade;
@property (nonatomic) int careerStatsFGAtt;
@property (nonatomic) int careerStatsFGMade;


+(instancetype)newKWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc fum:(int)fum dur:(int)dur;
+(instancetype)newKWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
