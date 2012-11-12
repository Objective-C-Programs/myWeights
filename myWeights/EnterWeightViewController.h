//
//  EnterWeightViewController.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitSelectorViewController.h"

@class WeightHistory;

@interface EnterWeightViewController : UIViewController
<UITextFieldDelegate, UnitSelectorViewControllerDelegate>

@property (nonatomic, strong) WeightHistory* weightHistory;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UIButton* unitsButton;

- (IBAction)saveWeight:(id)sender;
//- (IBAction)saveWeight:(id)sender;
- (IBAction)changeUnits:(id)sender;
- (IBAction)handleDownwardSwipe:(id)sender;
- (IBAction)handleUpwardSwipe:(id)sender;


+(NSString *)keyWeight;
+(NSString *)keyDate;
+(NSString *)plistName;

+ (BOOL)withData;

@end

