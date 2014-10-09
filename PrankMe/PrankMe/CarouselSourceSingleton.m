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
                                       nil];

        self.brokenGlassSecondBundle = [NSMutableArray arrayWithObjects:
                                        @[
                                        @{@"image": @"glassBundle2_1",
                                          @"title": @"Glass6",},
                                        @{@"image": @"glassBundle2_2",
                                          @"title": @"Glass7",},
                                        @{@"image": @"glassBundle2_3",
                                          @"title": @"Glass8",},
                                        @{@"image": @"glassBundle2_4",
                                          @"title": @"Glass9",},
                                        @{@"image": @"glassBundle2_5",
                                          @"title": @"Glass10",}],
                                        nil];
        self.brokenGlassThirdBundle = [NSMutableArray arrayWithObjects:
                                       @[@{@"image": @"glassBundle3_1",
                                         @"title": @"Glass11"},
                                       @{@"image": @"glassBundle3_2",
                                         @"title": @"Glass12"},
                                       @{@"image": @"glassBundle3_3",
                                         @"title": @"Glass13"},
                                       @{@"image": @"glassBundle3_4",
                                         @"title": @"Glass14"},
                                       @{@"image": @"glassBundle3_5",
                                         @"title": @"Glass15"}],
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
                                              @"title": @"Scratch3"},
                                            @{@"image": @"scratchBundle1_2",
                                              @"title": @"Scratch4"},
                                            @{@"image": @"scratchBundle1_3",
                                              @"title": @"Scratch5"},
                                            @{@"image": @"scratchBundle1_4",
                                              @"title": @"Scratch6"}],
                                          nil];
        self.scratchesSecondBundle = [NSMutableArray arrayWithObjects:
                                          @[@{@"image": @"scratchBundle2_1",
                                              @"title": @"Scratch7"},
                                            @{@"image": @"scratchBundle2_2",
                                              @"title": @"Scratch8"},
                                            @{@"image": @"scratchBundle2_3",
                                              @"title": @"Scratch9"},
                                            @{@"image": @"scratchBundle2_4",
                                              @"title": @"Scratch10"}],
                                          nil];
        
        self.allScratchesBundles = [NSMutableArray arrayWithObjects:self.scratchesFirstBundle, self.scratchesSecondBundle, nil];
        
        self.sprayFilters = [NSMutableArray arrayWithObjects:
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
        
        self.sprayFirstBundle = [NSMutableArray arrayWithObjects:
                                       @[
                                         @{@"image": @"spreyBundle1_1",
                                           @"title": @"Spray7"},
                                         @{@"image": @"spreyBundle1_2",
                                           @"title": @"Spray8",},
                                         @{@"image": @"spreyBundle1_3",
                                           @"title": @"Spray9"},
                                         @{@"image": @"spreyBundle1_4",
                                           @"title": @"Spray10"},
                                         @{@"image": @"spreyBundle1_5",
                                           @"title": @"Spray11"}
                                         ],
                                       nil];
        
        self.spraySecondBundle = [NSMutableArray arrayWithObjects:
                                        @[
                                          @{@"image": @"spreyBundle2_1",
                                            @"title": @"Spray12",},
                                          @{@"image": @"spreyBundle2_2",
                                            @"title": @"Spray13",},
                                          @{@"image": @"spreyBundle2_3",
                                            @"title": @"Spray14",},
                                          @{@"image": @"spreyBundle2_4",
                                            @"title": @"Spray15",}
                                          ],
                                        nil];
        self.sprayThirdBundle = [NSMutableArray arrayWithObjects:
                                       @[@{@"image": @"spreyBundle3_1",
                                           @"title": @"Spray16"},
                                         @{@"image": @"spreyBundle3_2",
                                           @"title": @"Spray17"},
                                         @{@"image": @"spreyBundle3_3",
                                           @"title": @"Spray18"},
                                         @{@"image": @"spreyBundle3_4",
                                           @"title": @"Spray19"},
                                         @{@"image": @"spreyBundle3_5",
                                           @"title": @"Spray20"}],
                                       nil];
        self.sprayFourthBundle = [NSMutableArray arrayWithObjects:
                                 @[@{@"image": @"spreyBundle4_1",
                                     @"title": @"Spray21"},
                                   @{@"image": @"spreyBundle4_2",
                                     @"title": @"Spray22"},
                                   @{@"image": @"spreyBundle4_3",
                                     @"title": @"Spray23"},
                                   @{@"image": @"spreyBundle4_4",
                                     @"title": @"Spray24"},
                                   @{@"image": @"spreyBundle4_5",
                                     @"title": @"Spray25"}],
                                 nil];
        
        self.allSprayBundles = [NSMutableArray arrayWithObjects:self.sprayFirstBundle, self.spraySecondBundle, self.sprayThirdBundle, self.sprayFourthBundle, nil];
        
        self.allBundlesID = [NSMutableArray arrayWithObjects:
                             //Broken glass
                             @{@"key" :@"com.cratissoftware.prankem.extreme",
                               @"bundle" : self.brokenGlassFirstBundle,
                               @"group" : @(BrokenGlass)},
                             @{@"key" : @"com.cratissoftware.prankem.sharp",
                               @"bundle" : self.brokenGlassSecondBundle,
                               @"group" : @(BrokenGlass)},
                             @{@"key" : @"com.cratissoftware.prankem.crazed",
                               @"bundle" : self.brokenGlassThirdBundle,
                               @"group" : @(BrokenGlass)},
                             
                             //Scratch
                             @{@"key" : @"com.cratissoftware.prankem.claws",
                               @"bundle" : self.scratchesFirstBundle,
                               @"group" : @(Scratches)},
                             @{@"key" : @"com.cratissoftware.prankem.crazies",
                               @"bundle" : self.scratchesSecondBundle,
                               @"group" : @(Scratches)},
                             
                             //Spray
                             @{@"key" : @"com.cratissoftware.prankem.splash",
                               @"bundle" : self.sprayFirstBundle,
                               @"group" : @(Spray)},
                             @{@"key" : @"com.cratissoftware.prankem.doodles",
                               @"bundle" : self.spraySecondBundle,
                               @"group" : @(Spray)},
                             @{@"key" : @"com.cratissoftware.prankem.graffiti",
                               @"bundle" : self.sprayThirdBundle,
                               @"group" : @(Spray)},
                             @{@"key" : @"com.cratissoftware.prankem.scribbling",
                               @"bundle" : self.sprayFourthBundle,
                               @"group" : @(Spray)},
                             
                             nil];
        
    }
    return self;
}

- (NSArray *)getAllItems{
    return @[self.brokenGlassFilters, self.scratchesFilters, self.sprayFilters];
}

- (NSInteger)getAllItemsCount{
    return self.brokenGlassFilters.count + self.scratchesFilters.count + self.sprayFilters.count;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductsArrivedNotification object:nil userInfo:nil];
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
        case Spray:{
            [self.sprayFilters addObjectsFromArray:bundle[0]];
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
                    if (![self.brokenGlassFilters containsObject:bundleContent[0][0]]){
                        [self.brokenGlassFilters addObjectsFromArray:bundleContent[0]];
                    }
                    break;
                }
                case Scratches:
                {
                    NSArray *bundleContent = bundle[@"bundle"];
                    if (![self.scratchesFilters containsObject:bundleContent[0][0]]){
                        [self.scratchesFilters addObjectsFromArray:bundle[@"bundle"]];
                    }
                    break;
                }
                case Spray:
                {
                    NSArray *bundleContent = bundle[@"bundle"];
                    if (![self.sprayFilters containsObject:bundleContent[0][0]]){
                        [self.sprayFilters addObjectsFromArray:bundle[@"bundle"]];
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
}

@end
