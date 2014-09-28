//
//  BundleIAPHelper.m
//  PrankMe
//
//  Created by VIktor Sokolov on 25.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "BundleIAPHelper.h"

@implementation BundleIAPHelper

+ (BundleIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static BundleIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.cratissoftware.prankem.glassbundle1",
//                                      @"com.cratissoftware.prankem.glassbundle2",
//                                      @"com.cratissoftware.prankem.glassbundle3",
//                                      
//                                      @"com.cratissoftware.prankem.scratchesbundle1",
//                                      @"com.cratissoftware.prankem.scratchesbundle2",
//                                      
//                                      @"com.cratissoftware.prankem.spreybundle1",
//                                      @"com.cratissoftware.prankem.spreybundle2",
//                                      @"com.cratissoftware.prankem.spreybundle3",
//                                      @"com.cratissoftware.prankem.spreybundle4",
                                      
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
