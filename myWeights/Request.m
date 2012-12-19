//
//  Request.m
//  myWeights
//
//  Created by Marco Velluto on 17/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "Request.h"

@implementation Request

static NSString * const DOMAIN_SITO = @"http://77.43.32.198:80/da_backend/check.php";
static NSString * const ACTION_HEAD_RECORD = @"ensureactivationrecord";
static NSString * const ACTION_NEW_EVENT = @"event";

static NSString * const ACTION = @"Action";
static NSString * const UNIQUE_ID = @"Uniqueid";
static NSString * const PRODUCER_ID = @"Producerid";
static NSString * const APP_NAME = @"Appname";
static NSString * const TRACK_ONLY = @"Trackingonly";
static NSString * const DEVICE_INFO = @"Deviceinfo";

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
+ (void)requestWithDomain:(NSString *)domain{
    
    if (domain == nil) {
        domain = DOMAIN_SITO;
    }
    NSURL *url = [NSURL URLWithString:domain];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setURL:[NSURL URLWithString:domain]];
    
    [request setHTTPMethod:@"POST"];
    
    //[request setValue:@"checkresponding" forHTTPHeaderField:@"Action"];
    
    [request setValue:@"ensureactivationrecord" forHTTPHeaderField:@"Action"];
    [request setValue:@"iphone" forHTTPHeaderField:@"Uniqueid"];
    [request setValue:@"9" forHTTPHeaderField:@"Producerid"];
    [request setValue:@"myWeights" forHTTPHeaderField:@"Appname"];
    [request setValue:@"true" forHTTPHeaderField:@"Trackingonly"];
    [request setValue:@"iphone marco" forHTTPHeaderField:@"Deviceinfo"];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    
#warning Fare asincrona
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
#warning non funzionante
    if (error.userInfo != nil) {
        NSLog(@"***ERROR: %@", error.userInfo.description);
    }
}


/**
 Fa una request con i parametri indicati.
 
 *-> se si vuole utilizzare il domain di default
    passare nil.
 *-> se si vuole utilizzare l'action di default
    passare nil.
 */
+ (void)requestNewHeadRecordWithDomain:(NSString *)domain
                            withAction:(NSString *)action
                          withUniqueid:(NSString *)uniqueid
                        withProducerid:(NSString *)producerid
                           withAppName:(NSString *)appName
                      withTrackingOnly:(NSString *)trakingOnly
                        withDeviceInfo:(NSString *)deviceInfo {
    
    if (domain == nil) 
        domain = DOMAIN_SITO;
    
    if (action == nil)
        action = ACTION_HEAD_RECORD;
        
    NSURL *url = [NSURL URLWithString:domain];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setURL:[NSURL URLWithString:domain]];
    
    [request setHTTPMethod:@"POST"];
    
    //[request setValue:@"checkresponding" forHTTPHeaderField:@"Action"];
    
    [request setValue:[NSString stringWithFormat:@"%@", action] forHTTPHeaderField:[NSString stringWithFormat:@"%@", ACTION]];
    [request setValue:[NSString stringWithFormat:@"%@", uniqueid] forHTTPHeaderField:[NSString stringWithFormat:@"%@", UNIQUE_ID]];
    [request setValue:[NSString stringWithFormat:@"%@", producerid] forHTTPHeaderField:[NSString stringWithFormat:@"%@", PRODUCER_ID]];
    [request setValue:[NSString stringWithFormat:@"%@", appName] forHTTPHeaderField:[NSString stringWithFormat:@"%@", APP_NAME]];
    [request setValue:[NSString stringWithFormat:@"%@", trakingOnly] forHTTPHeaderField:[NSString stringWithFormat:@"%@", TRACK_ONLY]];
    [request setValue:[NSString stringWithFormat:@"%@", deviceInfo] forHTTPHeaderField:[NSString stringWithFormat:@"%@", DEVICE_INFO]];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    
#warning Fare asincrona
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
#warning non funzionante
    if (error.userInfo != nil) {
        NSLog(@"REQUEST HEAD SENT");
    }
}

/**
    Invia una request di creazione nuovo evento.
 
 *-> se si vuole utilizzare il domain di default
 passare nil.
 *-> se si vuole utilizzare l'action di default
 passare nil.
 *-> se si vuole utilizzare l'unique id di default
 passare nil.
 */
+ (void)requestEventWithDomain:(NSString *)domain
               withAction:(NSString *)action
             withUniqueId:(NSString *)uniqueId
            withEventCode:(NSString *)eventCode
         withEventDetails:(NSString *)eventDetails{
    
    
    if (domain == nil)
        domain = DOMAIN_SITO;
    
    if (action == nil)
        action = ACTION_NEW_EVENT;
    
    if (uniqueId == nil)
        uniqueId = [[UIDevice currentDevice]uniqueIdentifier];
    //_---_---____---_-_-__---__---------__---___
    NSURL *url = [NSURL URLWithString:domain];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];

     NSURLResponse *response = [[NSURLResponse alloc] init];
     NSError *error = [[NSError alloc] init];
    
#warning Fare asincrona
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //--- Creo un evento
    
    [request setValue:action forHTTPHeaderField:@"Action"];
    [request setValue:uniqueId forHTTPHeaderField:@"Uniqueid"];
    [request setValue:eventCode forHTTPHeaderField:@"Eventcode"];
    [request setValue:eventDetails forHTTPHeaderField:@"Eventdetails"];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    

}

/**
 Fa una richesta automatica con i valori di default.
 
 */
+ (void)requestAutomaticNewHeadRecord {
    
    NSString *uniqueId = [[UIDevice currentDevice]uniqueIdentifier];
    NSString *producerid = @"9";
    NSString *appName = @"myWeights";
    NSString *traking = @"true";
    NSString *deviceInfo = [[UIDevice currentDevice] name];

    
    [Request requestNewHeadRecordWithDomain:nil withAction:nil withUniqueid:uniqueId withProducerid:producerid withAppName:appName withTrackingOnly:traking withDeviceInfo:deviceInfo];
    
}
@end
