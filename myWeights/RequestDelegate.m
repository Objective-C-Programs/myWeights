//
//  RequestDelegate.m
//  myWeights
//
//  Created by Marco Velluto on 21/03/13.
//  Copyright (c) 2013 algos. All rights reserved.
//

#import "RequestDelegate.h"
#import "Request.h"

@implementation RequestDelegate



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    int k = 0;
    
    NSHTTPURLResponse *urlRestponse = [[NSHTTPURLResponse alloc] init];
    urlRestponse = (NSHTTPURLResponse *)response;
    
    NSDictionary * dic = [urlRestponse allHeaderFields];
    NSString *str = [dic objectForKey:@"success"];
    
    if ([str isEqualToString:@"true"]) {
        
        NSLog(@"_-_ Record Creato");
        
        //[Request requestEventWithDomain:nil withAction:nil withUniqueId:@"898" withEventCode:@"2" withEventDetails:@"Aggiunto peso"];
        //[Request sendEvent:nil];
        NSString *idDeviceStr = [NSString alloc];
        idDeviceStr = [idDeviceStr initWithString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];

        [Request requestEventWithDomain:nil withAction:nil withUniqueId:idDeviceStr withEventCode:@"91" withEventDetails:@"BHO"];
    }
    else {
        NSLog(@"*** Errore: Record non creato");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}
@end
