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
    Dents,
    Sprey
} Group;

@interface CarouselSourceSingleton : NSObject

@property (nonatomic, strong) NSMutableArray *brokenGlassFilters;
@property (nonatomic, strong) NSMutableArray *scratchesFilters;
@property (nonatomic, strong) NSMutableArray *dentsFilters;
@property (nonatomic, strong) NSMutableArray *spreyFilters;

+ (CarouselSourceSingleton *)sharedCarouselSourceSingleton;

- (void)unlockItemInGroup:(Group)group underIndex:(NSInteger)index;
- (NSArray *)getAllItems;
- (NSInteger)getAllItemsCount;

@end
