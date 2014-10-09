//
//  SourceSingleton.h
//  angel
//
//  Created by VIktor Sokolov on 14.02.14.
//  Copyright (c) 2014 Viktor Sokolov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef enum {
    BrokenGlass = 0,
    Scratches,
    Spray
} Group;

@interface CarouselSourceSingleton : NSObject

@property (nonatomic, strong) NSMutableArray *brokenGlassFilters;
@property (nonatomic, strong) NSMutableArray *scratchesFilters;
@property (nonatomic, strong) NSMutableArray *sprayFilters;

@property (nonatomic, strong) NSMutableArray *brokenGlassFirstBundle;
@property (nonatomic, strong) NSMutableArray *brokenGlassSecondBundle;
@property (nonatomic, strong) NSMutableArray *brokenGlassThirdBundle;
@property (nonatomic, strong) NSMutableArray *allBrokenGlassBundles;

@property (nonatomic, strong) NSMutableArray *scratchesFirstBundle;
@property (nonatomic, strong) NSMutableArray *scratchesSecondBundle;
@property (nonatomic, strong) NSMutableArray *allScratchesBundles;

@property (nonatomic, strong) NSMutableArray *sprayFirstBundle;
@property (nonatomic, strong) NSMutableArray *spraySecondBundle;
@property (nonatomic, strong) NSMutableArray *sprayThirdBundle;
@property (nonatomic, strong) NSMutableArray *sprayFourthBundle;
@property (nonatomic, strong) NSMutableArray *allSprayBundles;

@property (nonatomic, strong) NSMutableArray *allBundlesID;

@property (nonatomic, strong) NSArray *products;

+ (CarouselSourceSingleton *)sharedCarouselSourceSingleton;

- (NSArray *)getAllItems;
- (NSInteger)getAllItemsCount;

// IN-APPS METHODS
- (void)getInAppProducts;
- (SKProduct *)getProductById:(NSString *)productID;
- (NSMutableArray *)getBundleByProductID:(NSString *)productID;
- (NSString *)getProductIdByBundle:(NSArray *)bundle;
- (void)checkPurchasedBundles;
- (void)bundlePurchasedWithId:(NSString *)productID andGroup:(Group)group;
- (void)bundlePurchasedWithId:(NSString *)productID;

@end
