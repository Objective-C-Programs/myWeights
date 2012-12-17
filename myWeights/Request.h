//
//  Request.h
//  myWeights
//
//  Created by Marco Velluto on 17/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject

/**
    Fa una riquest con questi paramertri:
 
 'Action' = 'ensureactivationrecord'
 'Uniqueid'='device id'
 'Producerid'='il mio id di produttore'
 'Appname'='application name'
 'Trackingonly'='true'
 'Deviceinfo'='quello che vuoi dirmi sul tuo device'
 
 *-> Se si vuole utilizzare il domain di default, 
    passare nil come parametro
 */
- (void)requestWithDomain:(NSString *)domain;
@end
