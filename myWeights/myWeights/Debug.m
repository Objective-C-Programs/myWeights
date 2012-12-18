//
//  Debug.m
//  myInventario
//
//  Created by Marco Velluto on 16/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "Debug.h"

@implementation Debug

static BOOL const IN_DEBUG = YES;

+ (BOOL)inDebug{
    
    return IN_DEBUG;
}

/**
 Inserire questo metodo nella classe AppDelegate in modo che setti in automatico
 tutti i flag di debug a false.
 */
//TODO: Implementarequesto ogni volta che si aggiunge una nuova variabile di debug.
+ (void)setDebugForRun {
    if (! IN_DEBUG) {
        
        NORMAL_LOG = NO;
        
        //Voglio che gli errori vengano visualizzati anche durante l'esecuzione
        //ERROR_LOG = NO;
    }
}


@end
