//
//  UnitSelectorViewController.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WeightEntry.h"

@protocol UnitSelectorViewControllerDelegate;




@interface UnitSelectorViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>


@property (strong, nonatomic) IBOutlet UIPickerView *unitPickerView;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) id<UnitSelectorViewControllerDelegate>
delegate;

@property (assign, nonatomic) WeightUnit defaultUnit;

- (IBAction)done:(id)sender;

@end




@protocol UnitSelectorViewControllerDelegate <NSObject>

- (void)unitSelectorDone:(UnitSelectorViewController*)controller;

- (void)unitSelector:(UnitSelectorViewController*)controller
        changedUnits:(WeightUnit)unit;

@end

