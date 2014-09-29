//
//  SourceSingleton.m
//  angel
//
//  Created by VIktor Sokolov on 14.02.14.
//  Copyright (c) 2014 Viktor Sokolov. All rights reserved.
//

#import "CarouselSourceSingleton.h"
#import "BundleIAPHelper.h"

@implementation CarouselSourceSingleton

static CarouselSourceSingleton* _sharedGameManager = nil;

+ (CarouselSourceSingleton *)sharedCarouselSourceSingleton{
    if(!_sharedGameManager){
        _sharedGameManager = [[self alloc] init];
        return _sharedGameManager;
    }
    return _sharedGameManager;
}

- (id)init{
    if (self = [super init]) {
        
        self.brokenGlassFilters = [NSMutableArray arrayWithObjects:
                                   @{@"image": @"glassSeparator"},
                                   @{@"image": @"glassFree1",
                                     @"title": @"Glass1"},
                                   @{@"image": @"glassFree2",
                                     @"title": @"Glass2"},
                                   nil];
        self.brokenGlassFirstBundle = [NSMutableArray arrayWithObjects:
                                       @[
                                       @{@"image": @"glassBundle1_1",
                                         @"title": @"Glass3"},
                                       @{@"image": @"glassBundle1_2",
                                         @"title": @"Glass4",},
                                       @{@"image": @"glassBundle1_3",
                                         @"title": @"Glass5"}
                                       ],
                                       @{@"price":@"0,99 $"},
                                       nil];

        self.brokenGlassSecondBundle = [NSMutableArray arrayWithObjects:
                                        @[
                                        @{@"image": @"glassBundle2_1",
                                          @"title": @"glassBundle2_1",},
                                        @{@"image": @"glassBundle2_2",
                                          @"title": @"glassBundle2_2",},
                                        @{@"image": @"glassBundle2_3",
                                          @"title": @"glassBundle2_3",},
                                        @{@"image": @"glassBundle2_4",
                                          @"title": @"glassBundle2_4",},
                                        @{@"image": @"glassBundle2_5",
                                          @"title": @"glassBundle2_5",}],
                                        @{@"price":@"1,99 $"},
                                        nil];
        self.brokenGlassThirdBundle = [NSMutableArray arrayWithObjects:
                                       @[@{@"image": @"glassBundle3_1",
                                         @"title": @"glassBundle3_1"},
                                       @{@"image": @"glassBundle3_2",
                                         @"title": @"glassBundle3_2"},
                                       @{@"image": @"glassBundle3_3",
                                         @"title": @"glassBundle3_3"},
                                       @{@"image": @"glassBundle3_4",
                                         @"title": @"glassBundle3_4"},
                                       @{@"image": @"glassBundle3_5",
                                         @"title": @"glassBundle3_5"}],
                                       @{@"price":@"1,99 $"},
                                       nil];
        
        self.allBrokenGlassBundles = [NSMutableArray arrayWithObjects:self.brokenGlassFirstBundle, self.brokenGlassSecondBundle, self.brokenGlassThirdBundle, nil];
        
        self.scratchesFilters = [NSMutableArray arrayWithObjects:
                                   @{@"image": @"scratchesSeparator"},
                                   @{@"image": @"scratchFree1",
                                     @"title": @"Scratch1"},
                                   @{@"image": @"scratchFree2",
                                     @"title": @"Scratch2"},
                                   nil];
        
        self.scratchesFirstBundle = [NSMutableArray arrayWithObjects:
                                          @[@{@"image": @"scratchBundle1_1",
                                              @"title": @"scratchBundle1_1"},
                                            @{@"image": @"scratchBundle1_2",
                                              @"title": @"scratchBundle1_2"},
                                            @{@"image": @"scratchBundle1_3",
                                              @"title": @"scratchBundle1_3"},
                                            @{@"image": @"scratchBundle1_4",
                                              @"title": @"scratchBundle1_4"}],
                                            @{@"price":@"0,99 $"},
                                          nil];
        self.scratchesSecondBundle = [NSMutableArray arrayWithObjects:
                                          @[@{@"image": @"scratchBundle2_1",
                                              @"title": @"scratchBundle2_1"},
                                            @{@"image": @"scratchBundle2_2",
                                              @"title": @"scratchBundle2_2"},
                                            @{@"image": @"scratchBundle2_3",
                                              @"title": @"scratchBundle2_3"},
                                            @{@"image": @"scratchBundle2_4",
                                              @"title": @"scratchBundle2_4"}],
                                          @{@"price":@"0,99 $"},
                                          nil];
        
        self.allScratchesBundles = [NSMutableArray arrayWithObjects:self.scratchesFirstBundle, self.scratchesSecondBundle, nil];
        
        self.spreyFilters = [NSMutableArray arrayWithObjects:
                                 @{@"image": @"spraySeparator"},
                                 @{@"image": @"spreyFree1",
                                   @"title": @"Spray1"},
                                 @{@"image": @"spreyFree2",
                                   @"title": @"Spray2"},
                                 @{@"image": @"spreyFree3",
                                   @"title": @"Spray3"},
                                 @{@"image": @"spreyFree4",
                                   @"title": @"Spray4"},
                                 @{@"image": @"spreyFree5",
                                   @"title": @"Spray5"},
                                 @{@"image": @"spreyFree6",
                                   @"title": @"Spray6"},
                                 nil];
        
        self.spreyFirstBundle = [NSMutableArray arrayWithObjects:
                                       @[
                                         @{@"image": @"spreyBundle1_1",
                                           @"title": @"spreyBundle1_1"},
                                         @{@"image": @"spreyBundle1_2",
                                           @"title": @"spreyBundle1_2",},
                                         @{@"image": @"spreyBundle1_3",
                                           @"title": @"spreyBundle1_3"},
                                         @{@"image": @"spreyBundle1_4",
                                           @"title": @"spreyBundle1_4"},
                                         @{@"image": @"spreyBundle1_5",
                                           @"title": @"spreyBundle1_5"}
                                         ],
                                       @{@"price":@"1,99 $"},
                                       nil];
        
        self.spreySecondBundle = [NSMutableArray arrayWithObjects:
                                        @[
                                          @{@"image": @"spreyBundle2_1",
                                            @"title": @"spreyBundle2_1",},
                                          @{@"image": @"spreyBundle2_2",
                                            @"title": @"spreyBundle2_2",},
                                          @{@"image": @"spreyBundle2_3",
                                            @"title": @"spreyBundle2_3",},
                                          @{@"image": @"spreyBundle2_4",
                                            @"title": @"spreyBundle2_4",}
                                          ],
                                        @{@"price":@"0,99 $"},
                                        nil];
        self.spreyThirdBundle = [NSMutableArray arrayWithObjects:
                                       @[@{@"image": @"spreyBundle3_1",
                                           @"title": @"spreyBundle3_1"},
                                         @{@"image": @"spreyBundle3_2",
                                           @"title": @"spreyBundle3_2"},
                                         @{@"image": @"spreyBundle3_3",
                                           @"title": @"spreyBundle3_3"},
                                         @{@"image": @"spreyBundle3_4",
                                           @"title": @"spreyBundle3_4"},
                                         @{@"image": @"spreyBundle3_5",
                                           @"title": @"spreyBundle3_5"}],
                                       @{@"price":@"1,99 $"},
                                       nil];
        self.spreyFourthBundle = [NSMutableArray arrayWithObjects:
                                 @[@{@"image": @"spreyBundle4_1",
                                     @"title": @"spreyBundle4_1"},
                                   @{@"image": @"spreyBundle4_2",
                                     @"title": @"spreyBundle4_2"},
                                   @{@"image": @"spreyBundle4_3",
                                     @"title": @"spreyBundle4_3"},
                                   @{@"image": @"spreyBundle4_4",
                                     @"title": @"spreyBundle4_4"},
                                   @{@"image": @"spreyBundle4_5",
                                     @"title": @"spreyBundle4_5"}],
                                 @{@"price":@"1,99 $"},
                                 nil];
        
        self.allSpreyBundles = [NSMutableArray arrayWithObjects:self.spreyFirstBundle, self.spreySecondBundle, self.spreyThirdBundle, self.spreyFourthBundle, nil];
        
        self.allBundlesID = [NSMutableArray arrayWithObjects:
                             @{@"key" :@"com.cratissoftware.prankem.glassbundle1",
                               @"bundle" : self.brokenGlassFirstBundle,
                               @"group" : @(BrokenGlass)},
                             @{@"key" : @"com.cratissoftware.prankem.glassbundle2",
                               @"bundle" : self.brokenGlassSecondBundle,
                               @"group" : @(BrokenGlass)},
                             @{@"key" : @"com.cratissoftware.prankem.glassbundle3",
                               @"bundle" : self.brokenGlassThirdBundle,
                               @"group" : @(BrokenGlass)},
                             
                             @{@"com.cratissoftware.prankem.scratchesbundle1": self.scratchesFirstBundle},
                             @{@"com.cratissoftware.prankem.scratchesbundle2": self.scratchesSecondBundle},
                             
                             @{@"com.cratissoftware.prankem.spreybundle1": self.spreyFirstBundle},
                             @{@"com.cratissoftware.prankem.spreybundle2": self.spreySecondBundle},
                             @{@"com.cratissoftware.prankem.spreybundle3": self.spreyThirdBundle},
                             @{@"com.cratissoftware.prankem.spreybundle4": self.spreyFourthBundle},
                             
                             nil];
        
    }
    return self;
}

- (NSArray *)getAllItems{
    return @[self.brokenGlassFilters, self.scratchesFilters, self.spreyFilters];
}

- (NSInteger)getAllItemsCount{
    return self.brokenGlassFilters.count + self.scratchesFilters.count + self.spreyFilters.count;
}

#pragma mark Work mafaka with In-apps

- (NSMutableArray *)getBundleByProductID:(NSString *)productID{
    NSMutableArray *bundleArray = [NSMutableArray array];
    for (int i = 0; i < self.allBundlesID.count; i++){
        NSDictionary *bundle  = self.allBundlesID[i];
        if ([bundle[@"key"] isEqualToString:productID]){
            bundleArray  = [NSMutableArray arrayWithArray:bundle[@"bundle"]];
        }
    }
    return bundleArray;
}

- (NSString *)getProductIdByBundle:(NSArray *)bundle{
    __block NSString *productName;
    for (int i = 0; i < self.allBundlesID.count; i++){
        NSDictionary *bundleDict  = self.allBundlesID[i];
        [bundleDict enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *object, BOOL *stop) {
            if (bundle == object){
                productName = bundleDict[@"key"];
            }
        }];
    }
    return productName;
}

- (void)getInAppProducts{
    [[BundleIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
        }
        NSLog(@"%@", self.products);
    }];
}

- (SKProduct *)getProductById:(NSString *)productID{
    SKProduct *product = [[SKProduct alloc] init];
    for (SKProduct *prod in self.products){
        if([prod.productIdentifier isEqualToString:productID]){
            product = prod;
        }
    }
    return product;
}

- (void)bundlePurchasedWithId:(NSString *)productID andGroup:(Group)group{
    NSArray *bundle = [self getBundleByProductID:productID];
    switch (group) {
        case BrokenGlass:{
            [self.brokenGlassFilters addObjectsFromArray:bundle[0]];
            break;
        }
        case Scratches:{
            [self.scratchesFilters addObjectsFromArray:bundle[0]];
            break;
        }
        case Sprey:{
            [self.spreyFilters addObjectsFromArray:bundle[0]];
            break;
        }
        default:
            break;
    }
}

- (void)checkPurchasedBundles{
    for (int i = 0; i < self.allBundlesID.count; i++){
        NSDictionary *bundle = self.allBundlesID[i];
        if ([[BundleIAPHelper sharedInstance] productPurchased:bundle[@"key"]]){
            Group group = [bundle[@"group"] integerValue];
            switch (group) {
                case BrokenGlass:
                {
                    NSArray *bundleContent = bundle[@"bundle"];
                    [self.brokenGlassFilters addObjectsFromArray:bundleContent[0]];
                    break;
                }
                case Scratches:
                {
                    [self.scratchesFilters addObjectsFromArray:bundle[@"bundle"]];
                    break;
                }
                case Sprey:
                {
                    [self.spreyFilters addObjectsFromArray:bundle[@"bundle"]];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

@end
