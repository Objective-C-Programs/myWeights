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
#import "RequestDelegate.h"
#import "RequestEventDelegate.h"


@implementation Request

static NSString * const ACTION_NEW_EVENT = @"event";
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
 TODO: Creazione nuovo record.
 */
+ (void)reques2tAsyncWithDomain:(NSString *)domain{
    
    if (domain == nil) {
        domain = DOMAIN_SITO;
    }
    
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:DOMAIN_SITO]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:60.0];
    
    
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
    
    // -- ID device
    NSString *idDeviceStr = [NSString alloc];
    idDeviceStr = [idDeviceStr initWithString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];

    //-- INFO DEVICE
    
    NSString *deviceInfo = [[NSString alloc] init];
    deviceInfo = [deviceInfo stringByAppendingFormat:@"Name-%@", [[UIDevice currentDevice] name]];
    deviceInfo = [deviceInfo stringByAppendingFormat:@" Model-%@", [[UIDevice currentDevice] model]];
    deviceInfo = [deviceInfo stringByAppendingFormat:@" SysName-%@", [[UIDevice currentDevice] systemName]];
    deviceInfo = [deviceInfo stringByAppendingFormat:@" SysVer-%@", [[UIDevice currentDevice] systemVersion]];
    deviceInfo = [deviceInfo stringByAppendingFormat:@" SysVer-%@", [[UIDevice currentDevice] systemVersion]];
    
    [request setValue:@"ensureactivationrecord" forHTTPHeaderField:@"Action"];
    [request setValue:idDeviceStr forHTTPHeaderField:@"Uniqueid"];
    [request setValue:@"9" forHTTPHeaderField:@"Producerid"];
    [request setValue:@"myWeights" forHTTPHeaderField:@"Appname"];
    [request setValue:@"myWeights" forHTTPHeaderField:@"Appname"];
    [request setValue:@"true" forHTTPHeaderField:@"Trackingonly"];
    [request setValue:deviceInfo forHTTPHeaderField:@"Deviceinfo"];

    
    RequestDelegate *delegate = [[RequestDelegate alloc] init];
    NSURLConnection *urlConnetction = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    
    
    if (urlConnetction) {
        NSLog(@"Request Sent - %@", request);
    }
    else {
        NSLog(@"****ERROR: urlConnection is NIL");
        
    }
    
}

+ (void)requestWithDomain:(NSString *)domain {
    
    if (!domain) {
        domain = DOMAIN_SITO;
    }
    
    //-- Impostazioni Request
    NSURL *url = [NSURL URLWithString:domain];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // -- ID device
    NSString *idDeviceStr = [NSString alloc];
    idDeviceStr = [idDeviceStr initWithString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    //-- INFO DEVICE
    NSString *deviceInfo = [[NSString alloc] init];
    deviceInfo = [deviceInfo stringByAppendingFormat:@"Name: %@", [[UIDevice currentDevice] name]];
    deviceInfo = [deviceInfo stringByAppendingFormat:@" - Model: %@", [[UIDevice currentDevice] model]];
    deviceInfo = [deviceInfo stringByAppendingFormat:@" -  SysName: %@", [[UIDevice currentDevice] systemName]];
    deviceInfo = [deviceInfo stringByAppendingFormat:@" - SysVer: %@", [[UIDevice currentDevice] systemVersion]];
    
    //Nome app
    NSString *nameApp = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    //-- Riempio la request con le informazioni
    [request setValue:@"ensureactivationrecord" forHTTPHeaderField:ACTION];
    [request setValue:idDeviceStr forHTTPHeaderField:UNIQUE_ID];
    [request setValue:@"9" forHTTPHeaderField:PRODUCER_ID];
    [request setValue:nameApp forHTTPHeaderField:APP_NAME];
    
    [request setValue:@"true" forHTTPHeaderField:TRACK_ONLY];
    [request setValue:deviceInfo forHTTPHeaderField:DEVICE_INFO];
    
    // -- Invio Request
    RequestDelegate *delegate = [[RequestDelegate alloc] init];
    NSURLConnection *urlConnetction = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    
    
    if (urlConnetction) {
        NSLog(@"-_- Request Sent - %@", request);
    }
    else {
        NSLog(@"****ERROR: urlConnection is NIL");
        
    }
}


//TODO: Send Event
+ (void)sendEvent:(NSString *)domain{
    if (domain == nil) {
        domain = DOMAIN_SITO;
    }
    
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:DOMAIN_SITO]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:60.0];
    
    
    NSURL *url = [NSURL URLWithString:domain];
    
    
    
    
    //___
    
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
    
    RequestEventDelegate *eventDelegate = [[RequestEventDelegate alloc] init];
    NSURLConnection *urlConnetction = [[NSURLConnection alloc] initWithRequest:request delegate:eventDelegate];
    
    
    if (urlConnetction) {
        NSLog(@"Request Sent - %@", request);
    }
    else {
        NSLog(@"****ERROR: urlConnection is NIL");
        
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
    
        
    //_---_---____---_-_-__---__---------__---___
    NSURL *url = [NSURL URLWithString:domain];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    //--- Creo un evento
    [request setValue:action forHTTPHeaderField:@"Action"];
    [request setValue:uniqueId forHTTPHeaderField:@"Uniqueid"];
    [request setValue:eventCode forHTTPHeaderField:@"Eventcode"];
    [request setValue:eventDetails forHTTPHeaderField:@"Eventdetails"];
    
    RequestEventDelegate *delegate = [[RequestEventDelegate alloc] init];
    NSURLConnection *urlConnetction = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    
    if (urlConnetction) {
        NSLog(@"Request Sent - %@", request);
    }
    else {
        NSLog(@"****ERROR: urlConnection is NIL");
        
    }
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

    
    [Request requestAsyncNewHeadRecordWithDomain:nil withAction:nil withUniqueid:uniqueId withProducerid:producerid withAppName:appName withTrackingOnly:traking withDeviceInfo:deviceInfo];
}


@end
