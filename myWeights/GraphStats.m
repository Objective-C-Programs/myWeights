//
//  GraphStats.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "GraphStats.h"
#import "WeightEntry.h"

@interface GraphStats()

@property (copy, nonatomic) NSArray* entries;

@property (strong, nonatomic, readwrite) NSDate* startingDate;
@property (strong, nonatomic, readwrite) NSDate* endingDate;
@property (assign, nonatomic, readwrite) NSTimeInterval duration;

@property (assign, nonatomic, readwrite) CGFloat minWeight;
@property (assign, nonatomic, readwrite) CGFloat maxWeight;
@property (assign, nonatomic, readwrite) CGFloat weightSpan;

- (void)processArray:(NSArray*)weightEntries;

@end




@implementation GraphStats

@synthesize entries = _entries;

@synthesize startingDate = _startingDate;
@synthesize endingDate = _endingDate;
@synthesize duration = _duration;

@synthesize minWeight = _minWeight;
@synthesize maxWeight = _maxWeight;
@synthesize weightSpan = _weightSpan;

#pragma mark - Initializers

// Designated Initializer.
- (id)initWithWeightEntryArray:(NSArray*)weightEntries {
    
    if ((self = [super init])) {
        
        [self processArray:weightEntries];
    }
    
    return self;
}

// Superclass's Designated Initializer.
- (id)init {
    
    // Create with an empy array.
    return [self initWithWeightEntryArray:[NSArray array]];
}

#pragma mark - Public Methods

- (void)processWeightEntryUsingBlock:(void (^)(WeightEntry*)) block {
    
    for (WeightEntry* entry in self.entries) {
        block(entry);
    }
}

#pragma mark - private methods

- (void)processArray:(NSArray*)weightEntries {
    
    self.entries = weightEntries;
    
    // Handle the edge case where we have no
    // dates in our array.
    if ([weightEntries count] == 0) {
        
        NSDate* date = [NSDate date];
        self.startingDate = date;
        self.endingDate = date;
        self.duration = 0.0f;
        
        self.minWeight = 0.0f;
        self.maxWeight = 0.0f;
        self.weightSpan = 0.0f;
        
        return;
    }
    
    // The weight entries are in order from newest to oldest.
    // Ending date is stored in the first entry.
    id myEntry = [weightEntries objectAtIndex:0];
    self.endingDate = [myEntry date];
    
    // Starting date is stored in the last entry.
    myEntry = [weightEntries lastObject];
    self.startingDate = [myEntry date];
    
    self.duration = [self.endingDate
                     timeIntervalSinceDate:self.startingDate];
    
    self.minWeight = CGFLOAT_MAX;
    self.maxWeight = CGFLOAT_MIN;
    
    for (id currentEntry in weightEntries) {
        
        CGFloat weight = [currentEntry weightInLbs];
        if (weight < self.minWeight) self.minWeight = weight;
        if (weight > self.maxWeight) self.maxWeight = weight;
        
    }
    
    self.weightSpan = self.maxWeight - self.minWeight;
}



@end