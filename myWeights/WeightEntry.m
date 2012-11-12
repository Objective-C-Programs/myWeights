//
//  WeightEntry.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "WeightEntry.h"

static const CGFloat LBS_PER_KG = 2.20462262f;
static NSNumberFormatter* formatter;

@implementation WeightEntry

@synthesize weightInLbs = _weightInLbs;
@synthesize date = _date;
@synthesize idNumber = _idNumber;

#pragma mark - Conversion Methods

+ (CGFloat)convertLbsToKg:(CGFloat)lbs {
    
    return lbs / LBS_PER_KG;
}

+ (CGFloat)convertKgToLbs:(CGFloat)kg {
    
    return kg * LBS_PER_KG;
}

#pragma mark - String Methods

+ (NSString*)stringForUnit:(WeightUnit)unit {
    
    switch (unit) {
            
        case LBS:
            return @"lbs";
            
        case KG:
            return @"kg";
            
        default:
            [NSException raise:NSInvalidArgumentException
                        format:@"The value %d is not a valid WeightUnit", unit];
    }
    
    // This will never be executed.
    return @"";
}

+ (NSString*)stringForWeight:(CGFloat)weight ofUnit:(WeightUnit)unit {
    
    NSString* weightString =
    [formatter stringFromNumber:[NSNumber numberWithFloat:weight]];
    
    NSString* unitString = [WeightEntry stringForUnit:unit];
    
    return [NSString stringWithFormat:@"%@ %@",
            weightString,
            unitString];
}

+ (NSString*)stringForWeightInLbs:(CGFloat)weight inUnit:(WeightUnit)unit {
    
    CGFloat convertedWeight;
    switch (unit) {
            
        case LBS:
            convertedWeight = weight;
            break;
        case KG:
            convertedWeight = [WeightEntry convertLbsToKg:weight];
            break;
        default:
            [NSException raise:NSInvalidArgumentException
                        format:@"%d is not a valid WeightUnit", unit];
    }
    
    
    return [WeightEntry stringForWeight:convertedWeight ofUnit:unit];
}

#pragma mark - Init Methods

+ (void)initialize {
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimum:[NSNumber numberWithFloat:0.0f]];
    [formatter setMaximumFractionDigits:2];
    
}

// Designated initializer.
- (id) initWithWeight:(CGFloat)weight
           usingUnits:(WeightUnit)unit
              forDate:(NSDate*)date
         withIdNumber:(int)idNumberTemp{
    
    self = [super init];
    if (self) {
        
        if (unit == LBS) {
            _weightInLbs = weight;
        }
        else {
            _weightInLbs = [WeightEntry convertKgToLbs:weight];
        }
        
        _date = date;
        _idNumber = idNumberTemp;
        
    }
    
    return self;
}

// Must override the superclass’s designated initializer.
- (id)init {
    
    NSDate* referenceDate = [NSDate dateWithTimeIntervalSince1970:0.0f];
    
    return [self initWithWeight:0.0f
                     usingUnits:LBS
                        forDate:referenceDate
                   withIdNumber:_idNumber];
}

#pragma mark - Public Methods

- (CGFloat)weightInUnit:(WeightUnit)unit {
    
    switch (unit) {
            
        case LBS:
            return self.weightInLbs;
            
        case KG:
            return [WeightEntry convertLbsToKg:self.weightInLbs];
            
        default:
            [NSException raise:NSInvalidArgumentException
                        format:@"The value %d is not a valid WeightUnit", unit];
    }
    
    // This will never be executed.
    return 0.0f;
}

- (NSString*)stringForWeightInUnit:(WeightUnit)unit {
    
    return [WeightEntry stringForWeight:[self weightInUnit:unit]
                                 ofUnit:unit];
}


@end

