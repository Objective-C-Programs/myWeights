//
//  HistoryCell.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightEntry.h"
#import "Pesi.h"

@interface HistoryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* weightLabel;
@property (nonatomic, strong) IBOutlet UILabel* dateLabel;


- (void)configureWithWeightEntry:(WeightEntry*)entry
                    defaultUnits:(WeightUnit)unit;

- (void)configureWithWeightPesate:(Pesi *)pesate
                     defaultUnits:(WeightUnit)unit;

@end