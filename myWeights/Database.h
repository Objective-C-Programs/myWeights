//
//  Database.h
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeightEntry.h"
#import "EnterWeightViewController.h"
#import "sqlite3.h"

static NSString * const TABLE_NAME = @"Pesi";
//static NSString * const TABLE_NAME = @"Pesate";
static NSString * const FIELD_WEIGHT = @"peso";
static NSString * const FIELD_DATE = @"data";

static BOOL const DELETE_ALL = NO;
static BOOL const WITH_SQLITE = YES;
static BOOL const WITH_LOG = YES;

@interface Database : NSObject
{
    sqlite3 *db;
}

@property (nonatomic)EnterWeightViewController *weight;

- (NSString *) filePath;
- (void) insertRecordWithWeight:(float)weight date:(double)date;
//- (void) insertRecordWithWeight:(float)weight data:(NSDate *)date;
- (void) openDB;
- (void)createTable;
- (void)createTablePesate;
- (NSArray *)getAllPesi;
- (int)countOfDb;
//- (void)compattoDB;
//- (char *)deleteAll;
- (char *)DeleteTable:(NSString *)table;
- (void) removeDbAtIndexes:(int)indexes;
- (int)lastValue;
- (void)removeAll;

+ (NSString *)tableName;
@end

