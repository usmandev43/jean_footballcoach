//
//  TeamViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewController.h"
@class Team;
@interface TeamViewController : FCTableViewController
-(instancetype)initWithTeam:(Team*)team;
@end
