//
//  WeightHistory.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeightEntry.h"

static NSString* const WeightHistoryChangedDefaultUnitsNotification =
@"WeightHistory changed the default units";

static NSString* const KVOWeightChangeKey = @"weightHistory";



@interface WeightHistory : NSObject

// This is a virtual property.
@property (nonatomic, readonly) NSArray* weights;
@property (nonatomic, assign, readwrite) WeightUnit defaultUnits;

- (void)addWeight:(WeightEntry*)weight;
- (void)removeWeightAtIndex:(NSUInteger)index;
- (int)countOfWeightHistory;


@end