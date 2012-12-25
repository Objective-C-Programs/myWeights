//
//  NSObject+Database.m
//  myWeights
//
//  Created by Marco Velluto on 22/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "NSObject+Database.h"

@implementation NSObject (Database)

//*********************************
#pragma mark - Init Methods
//*********************************

/**
 Crea un percorso per aprire il db.
 
 @discussion
 database.sql è il nome di defaul con cui è chiamato il db.
 */
- (NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"database.sql"];
}

/**
 Apre il database.
 */
- (sqlite3 *) openDBFromDB:(sqlite3 *)db {
    
    //-- Create Database --
    if (sqlite3_open([[self filePath] UTF8String], &(db)) != SQLITE_OK) {
        
        sqlite3_close(db);
        WITH_LOG ? NSLog(@"Database falied to open.") : nil;
    }
    return db;
}

//*********************************
#pragma mark - Utility Methods
//*********************************

/**
 Restuisce quanti record ho nella tabella.
 
 @param tableName -> nome tabella.
 @return int -> quanti record ho nel db.
 */
- (int)countOfDbFromTableNamed:(NSString *)tableName fromDB:(sqlite3 *)db {
    
    NSString * qsql = [NSString stringWithFormat:@"SELECT * FROM '%@'", tableName];
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

//*********************************
#pragma mark - Remove Methods
//*********************************

/**
 Elimina la tabella passata.
 
 @param table -> nome della tabella da eliminare.
 @return db -> database sul quale è stata eseguita l'operazione.
 */
- (sqlite3 *)DeleteTable:(NSString *)table fromDB:(sqlite3 *)db {

    
    NSString *query = [NSString stringWithFormat:@"DROP TABLE \"main\".\"%@\"", table];
    char *err;
    if (sqlite3_exec(db, [query UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"****** Error Delete table %@, with error. '%s'", table,err);
    }
    else
        WITH_LOG ? NSLog(@"Table %@ Delete Successfull", table) : nil;
    return db;
}

/**
 Elimina un record dalla tabella passata e al posto index passato.
 
 @param tableName -> nome tabella dal quale si vuole eliminare il record.
 @param index -> n° record che si vuole eliminare.
 @param db -> database che si vuole utilizzare.
 
 @return db -> db con le operazioni applicate.
 */
- (sqlite3 *) removeObjectFromTableNamed:(NSString *)tableName atIndex:(int)index fromDB:(sqlite3 *)db {

    NSString *str = [tableName stringByAppendingFormat:@".id"];
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %i", tableName, str, index];
    sqlite3_stmt *compiledStatement;
    char *err;
    if (sqlite3_exec(db, [query UTF8String], nil, &compiledStatement, &err) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"****** Error Delete Record. '%s'", err);
    }
    else {
        WITH_LOG ? NSLog(@"Record %i Delete Successfull", index) : nil;
    }
    return db;
}

/**
 Svuota la tabella passata da tutti gli elementi.
 
 @param tableName -> Tabella dal quale eliminare i record.
 @param db -> Database dove applicare l'operazione.
 
 @return db -> Database con l'operazione di eliminazione applicata.
 */
- (sqlite3 *)removeAllFromTableNamed:(NSString *)tableName fromDB:(sqlite3 *)db {
    
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
    return db;
}


@end
