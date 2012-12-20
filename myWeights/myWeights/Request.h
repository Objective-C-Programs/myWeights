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
 @method 
    Fa una riquest con questi paramertri:
 
 @discussion 
    I campi utilizzati sono questi:
 
    'Action' = 'ensureactivationrecord'
    'Uniqueid'='device id'
    'Producerid'='il mio id di produttore'
    'Appname'='application name'
    'Trackingonly'='true'
    'Deviceinfo'='quello che vuoi dirmi sul tuo device'
 
 @throws
    Se si vuole utilizzare il domain di default, 
    passare nil come parametro
 */
+ (void)requestWithDomain:(NSString *)domain;

/**
 
 @method 
    Fa una request con i parametri indicati.
 
 @throws
    * se si vuole utilizzare il domain di default
    passare nil.
    * se si vuole utilizzare l'action di default
    passare nil.
 */
+ (void)requestNewHeadRecordWithDomain:(NSString *)domain
                            withAction:(NSString *)action
                          withUniqueid:(NSString *)uniqueid
                        withProducerid:(NSString *)producerid
                           withAppName:(NSString *)appName
                      withTrackingOnly:(NSString *)trakingOnly
                        withDeviceInfo:(NSString *)deviceInfo;

/**
 @method 
    Invia una request di creazione nuovo evento.
 
 @throws
    * se si vuole utilizzare il domain di default
    passare nil.
    * se si vuole utilizzare l'action di default
    passare nil.
    * se si vuole utilizzare l'unique id di default
    passare nil.
 */
+ (void)requestEventWithDomain:(NSString *)domain
                    withAction:(NSString *)action
                  withUniqueId:(NSString *)uniqueId
                 withEventCode:(NSString *)eventCode
              withEventDetails:(NSString *)eventDetails;

/**
 @method
    Fa una richesta automatica con i valori di default.
 
 @discussion
    Chiama ed inserisce in automatico i valori nel metodo
    requestNewHeadRecordWithDomain:withAcion:withUniqueis:withProducerir...
                                    
 */
+ (void)requestAutomaticNewHeadRecord;


@end
