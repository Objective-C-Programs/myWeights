//
//  DetailViewController.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeightHistory;

@interface DetailViewController : UITableViewController

@property (nonatomic, strong) WeightHistory* weightHistory;
@property (nonatomic, assign) NSUInteger selectedIndex;


@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *averageTextField;
@property (strong, nonatomic) IBOutlet UITextField *lossTextField;
@property (strong, nonatomic) IBOutlet UITextField *gainTextField;


@end
