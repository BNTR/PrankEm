//
//  SourceSingleton.h
//  angel
//
//  Created by VIktor Sokolov on 14.02.14.
//  Copyright (c) 2014 Viktor Sokolov. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@property (nonatomic, strong) NSMutableArray *scratchesGlassFirstBundle;
@property (nonatomic, strong) NSMutableArray *scratchesGlassSecondBundle;
@property (nonatomic, strong) NSMutableArray *allScratchesBundles;

@property (nonatomic, strong) NSMutableArray *spreyFirstBundle;
@property (nonatomic, strong) NSMutableArray *spreySecondBundle;
@property (nonatomic, strong) NSMutableArray *spreyThirdBundle;
@property (nonatomic, strong) NSMutableArray *spreyFourthBundle;
@property (nonatomic, strong) NSMutableArray *allSpreyBundles;

+ (CarouselSourceSingleton *)sharedCarouselSourceSingleton;

- (void)unlockItemInGroup:(Group)group underIndex:(NSInteger)index;
- (NSArray *)getAllItems;
- (NSInteger)getAllItemsCount;

@end
