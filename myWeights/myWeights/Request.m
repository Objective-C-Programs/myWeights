//
//  Request.m
//  myWeights
//
//  Created by Marco Velluto on 17/12/12.
//  Copyright (c) 2012 algos. All rights reserved.
//

#import "Request.h"

@implementation Request

static NSString * const URL = @"http://203.217.146.44:81/POS/api.php?fn=cashRequest";
static NSString * const DOMAIN_LO = @"";

/**
 'uniqueid'='id unico del device'
 'action'='event'
 'eventcode'='1'
 'eventdetails'='i miei dettagli'
 */
- (void)request{
    
    NSString *domain = @"192.168.0.100/da_backend/check.php";
    NSURL *url = [NSURL URLWithString:domain];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //[request setURL:[NSURL URLWithString:domain]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"1" forHTTPHeaderField:@"eventcode"];    
    [request setValue:@"pippoz" forHTTPHeaderField:@"eventdetails"];
    
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    /*
    NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"reply string is :%@",replyString);
    */
}
@end
