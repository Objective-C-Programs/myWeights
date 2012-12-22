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
#import "NSObject+Database.h"

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

//********************************
#pragma mark - Metodi Specifici
//********************************

/**
 Inserisce un nuovo record nella tabella di default con i seguenti parametri.
 
 @param weight -> peso.
 @param date -> data di inserimento del peso.
 */
- (void) insertRecordWithWeight:(float)weight date:(double)date;

/**
 Crea una tabella con il nome della tavola di default.
 */
- (void)createTable;

/**
 Crea una tabella con il nome della tavola di default.
 */
- (void)createTablePesate;

/**
 Restituisce un array con dentro tutti gli elementi nella tabella.
 
 @return NSArray -> un aray di WeightEntry
 */
- (NSArray *)getAllPesi;


//********************************
#pragma mark - Metodi Standard
//********************************

/**
 Crea un percorso per aprire il db.
 
 @discussion 
    database.sql è il nome di defaul con cui è chiamato il db.
 */
- (NSString *) filePath;

/**
 Apre il database.
 */
- (void) openDB;

/**
 Crea una tabella con il nome passato.
 
 @param tableName -> nome della tabella da creare.
 */
- (void)createTableNamed:(NSString *)tableName;

/**
 Restuisce quanti record ho nella tabella di defaul.
 
 @return int -> quanti record ho nel db.
 */
- (int)countOfDb;

/**
 Restuisce quanti record ho nella tabella.
 
 @param tableName -> nome tabella.
 @return int -> quanti record ho nel db.
 */
- (int)countOfDbFromTableNamed:(NSString *)tableName;

/**
 Elimina la tabella passata.
 
 @param table -> nome della tabella da eliminare.
 */
- (char *)DeleteTable:(NSString *)table;

/**
 Elimina un record dalla tabella di default dato l'index.
 
 @param index -> numero del record da eliminare.
 */
- (void) removeDbAtIndexes:(int)indexes;

/**
 Elimina un record dalla tabella passata e al posto index passato.
 
 @param tableName -> nome tabella dal quale si vuole eliminare il record.
 @param index -> n° record che si vuole eliminare.
 */
- (void) removeObjectFromTableNamed:(NSString *)tableName atIndex:(int)index;

/**
 Restituisce il n°record dell'ultimo valore
 */
- (int)lastValue;

/**
 Svuolta la tabella di default da tutti gli elementi.
 */
- (void)removeAll;

/**
 Svuota la tabella passata da tutti gli elementi.
 
 @param tableName -> Tabella dal quale eliminare i record.
 */
- (void)removeAllFromTableNamed:(NSString *)tableName;

/**
 Restutisci il nome della tabella di defaul.
 
 @return -> il nome della tabella di defaul.
 */
+ (NSString *)tableName;

//- (void)compattoDB;
//- (void) insertRecordWithWeight:(float)weight data:(NSDate *)date;

//- (char *)deleteAll;

@end

