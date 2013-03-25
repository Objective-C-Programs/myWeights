//
//  RequestEventDelegate.h
//  myWeights
//
//  Created by Marco Velluto on 21/03/13.
//  Copyright (c) 2013 algos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestEventDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLConnectionDownloadDelegate, NSURLProtocolClient>

@end
