//
//  GraphStats.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeightEntry;



@interface GraphStats : NSObject

@property (strong, nonatomic, readonly) NSDate* startingDate;
@property (strong, nonatomic, readonly) NSDate* endingDate;
@property (assign, nonatomic, readonly) NSTimeInterval duration;

@property (assign, nonatomic, readonly) CGFloat minWeight;
@property (assign, nonatomic, readonly) CGFloat maxWeight;
@property (assign, nonatomic, readonly) CGFloat weightSpan;


- (id)initWithWeightEntryArray:(NSArray*)weightEntries;
- (void)processWeightEntryUsingBlock:(void (^)(WeightEntry*)) block;

@end
