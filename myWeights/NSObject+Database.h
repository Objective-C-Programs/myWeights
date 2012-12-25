//
//  NSObject+Database.h
//  myWeights
//
//  Created by Marco Velluto on 22/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Database.h"
#import "Request.h"
@interface NSObject (Database)

//*********************************
#pragma mark - Init Methods
//*********************************

/**
 Crea un percorso per aprire il db.
 
 @discussion
 database.sql è il nome di defaul con cui è chiamato il db.
 */
- (NSString *) filePath;

/**
 Apre il database.
 */
- (sqlite3 *) openDBFromDB:(sqlite3 *)db;

//*********************************
#pragma mark - Utility Methods
//*********************************

/**
 Restuisce quanti record ho nella tabella.
 
 @param tableName -> nome tabella.
 @return int -> quanti record ho nel db.
 */
- (int)countOfDbFromTableNamed:(NSString *)tableName fromDB:(sqlite3 *)db;

//*********************************
#pragma mark - Remove Methods
//*********************************

/**
 Elimina la tabella passata.
 
 @param table -> nome della tabella da eliminare.
 @return db -> database sul quale è stata eseguita l'operazione.
 */
- (sqlite3 *)DeleteTable:(NSString *)table fromDB:(sqlite3 *)db;

/**
 Elimina un record dalla tabella passata e al posto index passato.
 
 @param tableName -> nome tabella dal quale si vuole eliminare il record.
 @param index -> n° record che si vuole eliminare.
 @param db -> database che si vuole utilizzare.
 
 @return db -> db con le operazioni applicate.
 */
- (sqlite3 *) removeObjectFromTableNamed:(NSString *)tableName atIndex:(int)index fromDB:(sqlite3 *)db;

/**
 Svuota la tabella passata da tutti gli elementi.
 
 @param tableName -> Tabella dal quale eliminare i record.
 @param db -> Database dove applicare l'operazione.
 
 @return db -> Database con l'operazione di eliminazione applicata.
 */
- (sqlite3 *)removeAllFromTableNamed:(NSString *)tableName fromDB:(sqlite3 *)db;

@end
