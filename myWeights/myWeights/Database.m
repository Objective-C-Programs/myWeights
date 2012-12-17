//
//  Database.m
//  myWeights
//
//  Created by Marco Velluto on 12/11/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "Database.h"
#import "WeightEntry.h"
#import "sqlite3.h"
#import "Pesi.h"
#import "WeightHistory.h"
#import "EnterWeightViewController.h"

@implementation Database
@synthesize weight = _weight;


#pragma mark - Database Methods

- (NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"database.sql"];
}

- (void) openDB {
    
    //-- Create Database --
    if (sqlite3_open([[self filePath] UTF8String], &(db)) != SQLITE_OK) {
        
        sqlite3_close(db);
        WITH_LOG ? NSLog(@"Database falied to open.") : nil;
    }
}

- (void)createTable{
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "INTEGER PRIMARY KEY, '%@' REAL, '%@' REAL);", TABLE_NAME, @"id", FIELD_WEIGHT , FIELD_DATE];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"Table %@ falied create.", TABLE_NAME);
    }
}

- (void)createTablePesate{
    
    char *err;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' "
                     "INTEGER PRIMARY KEY, '%@' REAL, '%@' DATE);", TABLE_NAME, @"id", FIELD_WEIGHT , FIELD_DATE];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"Table %@ falied create.", TABLE_NAME);
    }
}


- (void) insertRecordWithWeight:(float)weight date:(double)date {
    int countOfDb = 0;
    countOfDb = [self countOfDb];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' ('%@','%@','%@')"
                     "VALUES ('%d','%f','%f')", TABLE_NAME, @"id",FIELD_WEIGHT, FIELD_DATE, countOfDb, weight, date];
    
    
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"****** Not Posssible Insert New Record In %@, with error: '%s'", TABLE_NAME,err);
    }
}

- (NSArray *)getAllPesi{
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM '%@'", TABLE_NAME];
    sqlite3_stmt *statment;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            WeightEntry * entry = [WeightEntry alloc];
            
            //char *field1 = (char *) sqlite3_column_text(statment, 0);
            //NSString *field1Str = [[NSString alloc] initWithUTF8String:field1];
            
            char *field2 = (char *) sqlite3_column_text(statment, 1);
            NSString *field2Str = [[NSString alloc] initWithUTF8String:field2];
            
            
            int idNumber = (int) sqlite3_column_int(statment, 0);
            
            //char *field3 = (char *)sqlite3_column_text(statment, 2);
            
            double field3 = sqlite3_column_double(statment, 2);
            
            
            //NSString *field3Str = [[NSString alloc] initWithUTF8String:field3];
            
            //double dataInFloat = [field3Str doubleValue];
            float peso = [field2Str floatValue];
            
            NSDate *ddd = [[NSDate alloc] initWithTimeIntervalSince1970:field3];
            
            //ddd = [ddd dateByAddingTimeInterval:field3];
            
            //entry = [entry initWithWeight:peso usingUnits:LBS forDate:ddd];
            entry = [entry initWithWeight:peso usingUnits:_weight.weightHistory.defaultUnits forDate:ddd withIdNumber:idNumber];
            [tempArray addObject:entry];
            
            //WITH_LOG ? NSLog(@" %@ - %@ - %@", field1Str, field2Str, /*field3Str*/) : nil;
        }//end while
        WITH_LOG ? NSLog(@"_____________________________________________________") : nil;
        sqlite3_finalize(statment);
    }//end if
    else
        NSLog(@"***** Error do not possible get all pesi");
    
    if ([tempArray count] == 0) {
        
        WITH_LOG ? NSLog(@"Non ci sono elementi nella tabella %@", TABLE_NAME) : nil;
    }
    return tempArray;
}


- (int)countOfDb {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM '%@'", TABLE_NAME];
    sqlite3_stmt *statment;
    
    int count = 0;
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            count ++;
        }
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
    else
        NSLog(@"****** Error Count of DB");
    return count;
}

- (int)lastValue {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM '%@' ORDER BY id", TABLE_NAME];
    sqlite3_stmt *statment;
    
    int count = 0;
    if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statment) == SQLITE_ROW) {
            count = (int)sqlite3_column_int(statment, 0);
        }
        //-- Delete the compiler statment from memory
        sqlite3_finalize(statment);
    }
    else
        NSLog(@"****** Error Count of DB");
    return count;
}

#pragma mark - Delete Methods

- (char *)DeleteTable:(NSString *)table {
    
    NSString *query = [NSString stringWithFormat:@"DROP TABLE \"main\".\"%@\"", table];
    char *err;
    if (sqlite3_exec(db, [query UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"****** Error Delete table %@, with error. '%s'", table,err);
    }
    else
        WITH_LOG ? NSLog(@"Table %@ Delete Successfull", table) : nil;
    
    return err;
}

- (void) removeDbAtIndexes:(int)indexes {
    
    NSString *str = [TABLE_NAME stringByAppendingFormat:@".id"];
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %i", TABLE_NAME, str, indexes];
    sqlite3_stmt *compiledStatement;
    char *err;
    if (sqlite3_exec(db, [query UTF8String], nil, &compiledStatement, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"****** Error Delete Record. '%s'", err);
    }
    else {
        WITH_LOG ? NSLog(@"Record %i Delete Successfull", indexes) : nil;
    }
}

- (void)removeAll {
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM \"main\".\"%@\"", TABLE_NAME];
    sqlite3_stmt *compiledStatement;
    char *err;
    if (sqlite3_exec(db, [query UTF8String], nil, &compiledStatement, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"******Error Empty Ithems from table %@, with error. '%s'", TABLE_NAME, err);
        sqlite3_close(db);
    }
    else {
        WITH_LOG ? NSLog(@"Empty Table %@ successfull", TABLE_NAME) : nil;
    }
}

+ (NSString *)tableName {
    
    return TABLE_NAME;
}

@end
