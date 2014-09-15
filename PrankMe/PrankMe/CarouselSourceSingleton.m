//
//  SourceSingleton.m
//  angel
//
//  Created by VIktor Sokolov on 14.02.14.
//  Copyright (c) 2014 Viktor Sokolov. All rights reserved.
//

#import "CarouselSourceSingleton.h"

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
                                   @{@"image": @"glass1",
                                     @"title": @"glass1"},
                                   @{@"image": @"glass2",
                                     @"title": @"glass2"},
                                   @{@"image": @"glass3",
                                     @"title": @"glass3"},
                                   nil];
        self.brokenGlassFirstBundle = [NSMutableArray arrayWithObjects:
                                       @[@{@"image": @"glass4",
                                         @"title": @"glass4"},
                                       @{@"image": @"glass5",
                                         @"title": @"glass5",},
                                       @{@"image": @"glass6",
                                         @"title": @"glass6"}],
                                       @{@"price":@"1,99 $"},
                                       nil];

        self.brokenGlassSecondBundle = [NSMutableArray arrayWithObjects:
                                        @[@{@"image": @"glass7",
                                          @"title": @"glass7",},
                                        @{@"image": @"glass8",
                                          @"title": @"glass8",},
                                        @{@"image": @"glass9",
                                          @"title": @"glass9",}],
                                        @{@"price":@"0,99 $"},
                                        nil];
        self.brokenGlassThirdBundle = [NSMutableArray arrayWithObjects:
                                       @[@{@"image": @"glass10",
                                         @"title": @"glass10"},
                                       @{@"image": @"glass11",
                                         @"title": @"glass11"},
                                       @{@"image": @"glass12",
                                         @"title": @"glass12"}],
                                       @{@"price":@"3,99 $"},
                                       nil];
        
        self.allBrokenGlassBundles = [NSMutableArray arrayWithObjects:self.brokenGlassFirstBundle, self.brokenGlassSecondBundle, self.brokenGlassThirdBundle, nil];
        
        self.scratchesFilters = [NSMutableArray arrayWithObjects:
                                   @{@"image": @"glassSeparator"},
                                   @{@"image": @"scratch1",
                                     @"title": @"scratch1"},
                                   @{@"image": @"scratch2",
                                     @"title": @"scratch2"},
                                   @{@"image": @"scratch3",
                                     @"title": @"scratch3"},
                                   nil];
        
        self.scratchesGlassFirstBundle = [NSMutableArray arrayWithObjects:
                                          @[@{@"image": @"scratch4",
                                              @"title": @"scratch4"},
                                            @{@"image": @"scratch5",
                                              @"title": @"scratch5"}],
                                            @{@"price":@"4,99 $"},
                                          nil];
        
        self.allScratchesBundles = [NSMutableArray arrayWithObjects:self.scratchesGlassFirstBundle, nil];
        
        self.dentsFilters = [NSMutableArray arrayWithArray:@[]];
        self.spreyFilters = [NSMutableArray arrayWithArray:@[]];
    }
    return self;
}

- (void)unlockItemInGroup:(Group)group underIndex:(NSInteger)index{
    switch (group) {
        case BrokenGlass:
        {
            NSDictionary *items = [self.brokenGlassFilters objectAtIndex:index];
            [items setValue:@(1) forKey:@"paied"];
            break;
        }
        case Scratches:
        {
            NSDictionary *items = [self.scratchesFilters objectAtIndex:index];
            [items setValue:@(1) forKey:@"paied"];
            break;
        }
        case Dents:
        {
            break;
        }
        case Sprey:
        {
            break;
        }
        default:
            break;
    }
}

- (NSArray *)getAllItems{
    return @[self.brokenGlassFilters, self.scratchesFilters, self.dentsFilters, self.spreyFilters];
}

- (NSInteger)getAllItemsCount{
    return self.brokenGlassFilters.count + self.scratchesFilters.count + self.dentsFilters.count + self.spreyFilters.count;
}

@end
