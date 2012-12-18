//
//  Debug.h
//  myInventario
//
//  Created by Marco Velluto on 16/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>

static BOOL NORMAL_LOG = YES;
static BOOL ERROR_LOG = YES;
static BOOL DATABASE_LOG = YES;

@interface Debug : NSObject

+ (BOOL)inDebug;
/**
 Inserire questo metodo nella classe AppDelegate in modo che setti in automatico
 tutti i flag di debug a false.
 */
+ (void)setDebugForRun;


@end
