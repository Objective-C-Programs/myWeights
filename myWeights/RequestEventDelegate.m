//
//  RequestEventDelegate.m
//  myWeights
//
//  Created by Marco Velluto on 21/03/13.
//  Copyright (c) 2013 algos. All rights reserved.
//

#import "RequestEventDelegate.h"

@implementation RequestEventDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    int k = 0;
    
    NSHTTPURLResponse *urlRestponse = [[NSHTTPURLResponse alloc] init];
    urlRestponse = (NSHTTPURLResponse *)response;
    
    NSDictionary * dic = [urlRestponse allHeaderFields];
    NSString *str = [dic objectForKey:@"success"];
    
    if ([str isEqualToString:@"true"]) {
        NSLog(@"_-_ Evento Creato");
        //[Request requestEventWithDomain:nil withAction:nil withUniqueId:@"898" withEventCode:@"2" withEventDetails:@"Aggiunto peso"];
    }
    else {
        NSLog(@"*** Errore: Impossibile creare evento");
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Error %@", error);
}

@end
