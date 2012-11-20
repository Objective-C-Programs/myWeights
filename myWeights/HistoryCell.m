//
//  HistoryCell.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "HistoryCell.h"
#import "Pesi.h"

@implementation HistoryCell

@synthesize weightLabel=_weightLabel;
@synthesize dateLabel=_dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureWithWeightEntry:(WeightEntry*)entry
                    defaultUnits:(WeightUnit)unit {
    
    self.weightLabel.text = [entry stringForWeightInUnit:unit];
    
    
    NSString *str = [NSDateFormatter localizedStringFromDate:entry.date
                                                   dateStyle:NSDateFormatterShortStyle
                                                   timeStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = str;
}


- (void)configureWithWeightPesate:(Pesi *)pesate
                     defaultUnits:(WeightUnit)unit {
    
    NSString *str = [[NSString alloc] initWithFormat:@"%f", [pesate peso]];
    self.weightLabel.text = str;
    
    NSString *dataStr = [[NSString alloc] initWithFormat:@"%f", [pesate data]];
    
    self.dateLabel.text = dataStr;
}

@end
