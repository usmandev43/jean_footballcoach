//
//  TeamHistoryViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewController.h"
@class Team;
@interface TeamHistoryViewController : FCTableViewController
-(instancetype)initWithTeam:(Team*)team;
@end
