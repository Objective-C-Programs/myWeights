//
//  HistoryViewController.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class WeightHistory;

@interface HistoryViewController : UITableViewController

@property (strong, nonatomic) WeightHistory* weightHistory;
@property (nonatomic) sqlite3 * db;
- (IBAction)deleteAllButtonPressed:(id)sender;
@end
