//
//  TeamSelectionViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewController.h"
@class League;

@interface TeamSelectionViewController : FCTableViewController
-(instancetype)initWithLeague:(League*)selectedLeague;
@end
