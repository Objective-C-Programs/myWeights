//
//  NSObject+Database.h
//  myWeights
//
//  Created by Marco Velluto on 22/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface NSObject (Database)

/**
 Svuota la tabella passata da tutti gli elementi.
 
 @param tableName -> Tabella dal quale eliminare i record.
 */
- (void)removeAllFromTableNamed:(NSString *)tableName fromDB:(sqlite3 *)db;
@end
