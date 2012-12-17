//
//  WeightEntry.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef enum {
    LBS,
    KG
} WeightUnit;



@interface WeightEntry : NSObject

@property (nonatomic, assign, readonly) CGFloat weightInLbs;
@property (nonatomic, strong, readonly) NSDate* date;
@property (nonatomic) int idNumber;

+ (CGFloat)convertLbsToKg:(CGFloat)lbs;
+ (CGFloat)convertKgToLbs:(CGFloat)kg;

+ (NSString*)stringForUnit:(WeightUnit)unit;
+ (NSString*)stringForWeight:(CGFloat)weight ofUnit:(WeightUnit)unit;
+ (NSString*)stringForWeightInLbs:(CGFloat)weight inUnit:(WeightUnit)unit;

- (id) initWithWeight:(CGFloat)weight
           usingUnits:(WeightUnit)unit
              forDate:(NSDate*)date
         withIdNumber:(int)idNumberTemp;

- (CGFloat)weightInUnit:(WeightUnit)unit;
- (NSString*)stringForWeightInUnit:(WeightUnit)unit;

@end
