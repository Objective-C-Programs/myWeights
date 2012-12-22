//
//  NSObject+Database.m
//  myWeights
//
//  Created by Marco Velluto on 22/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "NSObject+Database.h"

@implementation NSObject (Database)


/**
 Svuota la tabella passata da tutti gli elementi.
 
 @param tableName -> Tabella dal quale eliminare i record.
 */
- (void)removeAllFromTableNamed:(NSString *)tableName fromDB:(sqlite3 *)db{
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM \"main\".\"%@\"", tableName];
    sqlite3_stmt *compiledStatement;
    char *err;
    if (sqlite3_exec(db, [query UTF8String], nil, &compiledStatement, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"******Error Empty Ithems from table %@, with error. '%s'", tableName, err);
        sqlite3_close(db);
    }
    else {
        NSLog(@"Empty Table %@ successfull", tableName);
    }
    
}

@end
