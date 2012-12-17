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
- (void)requestWithDomain:(NSString *)domain{
    
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
@end
