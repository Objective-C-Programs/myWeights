//
//  WeightHistory.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "WeightHistory.h"

@interface WeightHistory()

@property (nonatomic, strong) NSMutableArray* weightHistory;

@end




@implementation WeightHistory

@synthesize weightHistory = _weightHistory;
@synthesize defaultUnits = _defaultUnits;

#pragma mark - virtual weights property

// This ensures key-value observing works for weights.
+ (NSSet *)keyPathsForValuesAffectingWeights {
    return [NSSet setWithObjects:@"weightHistory", nil];
}

// Virtual property implementation.
- (NSArray*) weights {
    
    return self.weightHistory;
}

#pragma mark - initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        // Set initial defaults.
        _defaultUnits = LBS;
        _weightHistory = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - accessor methods

- (void)setDefaultUnits:(WeightUnit)units {
    
    // If we are setting the current value, do nothing.
    if (_defaultUnits == units) return;
    
    _defaultUnits = units;
    
    // Send a notification.
    [[NSNotificationCenter defaultCenter]
     postNotificationName:WeightHistoryChangedDefaultUnitsNotification
     object:self];
}

#pragma mark - public methods

- (void)addWeight:(WeightEntry*)weight {
    
    // Manually send KVO messages.
    [self willChange:NSKeyValueChangeInsertion
     valuesAtIndexes:[NSIndexSet indexSetWithIndex:0]
              forKey:KVOWeightChangeKey];
    
    // Add to the front of the list.
    [self.weightHistory insertObject:weight atIndex:0];
    
    // Manually send KVO messages.
    [self didChange:NSKeyValueChangeInsertion
    valuesAtIndexes:[NSIndexSet indexSetWithIndex:0]
             forKey:KVOWeightChangeKey];
}
- (int )countOfWeightHistory {
    
    return [self.weightHistory count];
}
// This will be auto KVO'ed.
- (void)removeWeightAtIndex:(NSUInteger)weightIndex {
    
    // Manually send KVO messages.
    [self willChange:NSKeyValueChangeRemoval
     valuesAtIndexes:[NSIndexSet indexSetWithIndex:weightIndex]
              forKey:KVOWeightChangeKey];
    
    // Add to the front of the list.
    [self.weightHistory removeObjectAtIndex:weightIndex];
    
    // Manually send KVO messages.
    [self didChange:NSKeyValueChangeRemoval
    valuesAtIndexes:[NSIndexSet indexSetWithIndex:weightIndex]
             forKey:KVOWeightChangeKey];
}
@end
