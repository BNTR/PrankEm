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
    Sprey
} Group;

@interface CarouselSourceSingleton : NSObject

@property (nonatomic, strong) NSMutableArray *brokenGlassFilters;
@property (nonatomic, strong) NSMutableArray *scratchesFilters;
@property (nonatomic, strong) NSMutableArray *spreyFilters;

@property (nonatomic, strong) NSMutableArray *brokenGlassFirstBundle;
@property (nonatomic, strong) NSMutableArray *brokenGlassSecondBundle;
@property (nonatomic, strong) NSMutableArray *brokenGlassThirdBundle;
@property (nonatomic, strong) NSMutableArray *allBrokenGlassBundles;

@property (nonatomic, strong) NSMutableArray *scratchesFirstBundle;
@property (nonatomic, strong) NSMutableArray *scratchesSecondBundle;
@property (nonatomic, strong) NSMutableArray *allScratchesBundles;

@property (nonatomic, strong) NSMutableArray *spreyFirstBundle;
@property (nonatomic, strong) NSMutableArray *spreySecondBundle;
@property (nonatomic, strong) NSMutableArray *spreyThirdBundle;
@property (nonatomic, strong) NSMutableArray *spreyFourthBundle;
@property (nonatomic, strong) NSMutableArray *allSpreyBundles;

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

@end
