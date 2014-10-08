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
                                      //Broken glass
                                      @"com.cratissoftware.prankem.extreme",
                                      @"com.cratissoftware.prankem.sharp",
                                      @"com.cratissoftware.prankem.crazed",
                                      //Scratches
                                      @"com.cratissoftware.prankem.claws",
                                      @"com.cratissoftware.prankem.crazies",
                                      //Spray
                                      @"com.cratissoftware.prankem.splash",
                                      @"com.cratissoftware.prankem.doodles",
                                      @"com.cratissoftware.prankem.graffiti",
                                      @"com.cratissoftware.prankem.scribbling",
                                      
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
