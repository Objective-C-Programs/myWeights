//
//  Request.m
//  myWeights
//
//  Created by Marco Velluto on 17/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//
/*
 
 Nome Classe: DroidActivator. (Singleton)
 
 set indirizzo ip.
 init with domanin.
 
 */
#import "Request.h"
static NSString * const ACTION_NEW_EVENT = @"event";

@implementation Request

//static NSString * const DOMAIN_SITO = @"http://77.43.32.198:80/da_backend/check.php";
static NSString * const DOMAIN_SITO = @"http://droidactivator.algos.it/da_backend/check.php";
static NSString * const ACTION_HEAD_RECORD = @"ensureactivationrecord";
//static NSString * const ACTION_NEW_EVENT = @"event";

static NSString * const ACTION = @"Action";
static NSString * const UNIQUE_ID = @"Uniqueid";
static NSString * const PRODUCER_ID = @"Producerid";
static NSString * const APP_NAME = @"Appname";
static NSString * const TRACK_ONLY = @"Trackingonly";
static NSString * const DEVICE_INFO = @"Deviceinfo";

//--Lazy initialization per garantire che la classe sia un Singleton

+ (Request *)instance {
    // the instance of this class is stored here
    static Request *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}


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
}//end metohod

/**
 METODO DI PROVA PER NOTIFICA ASINCRONA
 
 */
+ (void)requestAsyncNewHeadRecordWithDomain:(NSString *)domain
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
} //end method


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
        uniqueId = [[UIDevice currentDevice] uniqueIdentifier];
    
    /**
    NSString *uuid (){
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        NSString *uuidString = CFUUIDCreate(__bridge_transfer NSString *) CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        return uuidString;
    }
    */
    
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
    NSString *traking = @"1";
    NSString *deviceInfo = [[UIDevice currentDevice] name];

    
    [Request requestNewHeadRecordWithDomain:nil withAction:nil withUniqueid:uniqueId withProducerid:producerid withAppName:appName withTrackingOnly:traking withDeviceInfo:deviceInfo];
    
}

#pragma mark - Async

+ (void)requestautomaticNewHeadRecordAsyncron {
    
    NSString *uniqueId = [[UIDevice currentDevice]uniqueIdentifier];
    NSString *producerid = @"9";
    NSString *appName = @"myWeights";
    NSString *traking = @"1";
    NSString *deviceInfo = [[UIDevice currentDevice] name];
    
    [Request requestNewAsycHeadRecordWithDomain:nil withAction:nil withUniqueid:uniqueId withProducerid:producerid withAppName:appName withTrackingOnly:traking withDeviceInfo:deviceInfo];
}



/**
 
 @method
 Fa una request con i parametri indicati.
 
 @throws
 * se si vuole utilizzare il domain di default
 passare nil.
 * se si vuole utilizzare l'action di default
 passare nil.
 */
+ (void)requestNewAsycHeadRecordWithDomain:(NSString *)domain
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
   // [NSURLConnection sendAsynchronousRequest:request queue:<#(NSOperationQueue *)#> completionHandler:<#^(NSURLResponse *, NSData *, NSError *)handler#>]
#warning non funzionante
    if (error.userInfo != nil) {
        NSLog(@"REQUEST HEAD SENT");
    }
}//end metohod


+ (void)sentCustonEventWithCode:(NSString *)code eventDetail:(NSString *)detail {
    NSString *uniqueId = [[UIDevice currentDevice]uniqueIdentifier];
    
    [Request requestautomaticNewHeadRecordAsyncron];
   // [Request requestNewAsycHeadRecordWithDomain:nil withAction:nil withUniqueid: withProducerid:<#(NSString *)#> withAppName:<#(NSString *)#> withTrackingOnly:<#(NSString *)#> withDeviceInfo:<#(NSString *)#>]
}

@end
