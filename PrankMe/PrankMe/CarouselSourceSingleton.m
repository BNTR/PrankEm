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
                                     @"title": @"glass1",
                                     @"paied": @(1)},
                                   @{@"image": @"glass2",
                                     @"title": @"glass2",
                                     @"paied": @(1)},
                                   @{@"image": @"glass3",
                                     @"title": @"glass3",
                                     @"paied": @(1)},
                                   @{@"image": @"glass4",
                                     @"title": @"glass4",
                                     @"paied": @(0)},
                                   @{@"image": @"glass5",
                                     @"title": @"glass5",
                                     @"paied": @(0)},
                                   @{@"image": @"glass6",
                                     @"title": @"glass6",
                                     @"paied": @(0)},
                                   @{@"image": @"glass7",
                                     @"title": @"glass7",
                                     @"paied": @(0)},
                                   @{@"image": @"glass8",
                                     @"title": @"glass8",
                                     @"paied": @(0)},
                                   @{@"image": @"glass9",
                                     @"title": @"glass9",
                                     @"paied": @(0)},
                                   @{@"image": @"glass10",
                                     @"title": @"glass10",
                                     @"paied": @(0)},
                                   @{@"image": @"glass11",
                                     @"title": @"glass11",
                                     @"paied": @(0)},
                                   @{@"image": @"glass12",
                                     @"title": @"glass12",
                                     @"paied": @(0)},
                                   @{@"image": @"glass13",
                                     @"title": @"glass13",
                                     @"paied": @(0)},
                                   @{@"image": @"glass14",
                                     @"title": @"glass14",
                                     @"paied": @(0)},
                                   @{@"image": @"glass15",
                                     @"title": @"glass15",
                                     @"paied": @(0)},
                                   nil];
        self.scratchesFilters = [NSMutableArray arrayWithObjects:
                                   @{@"image": @"glassSeparator"},
                                   @{@"image": @"scratch1",
                                     @"title": @"scratch1",
                                     @"paied": @(1)},
                                   @{@"image": @"scratch2",
                                     @"title": @"scratch2",
                                     @"paied": @(1)},
                                   @{@"image": @"scratch3",
                                     @"title": @"scratch3",
                                     @"paied": @(1)},
                                   @{@"image": @"scratch4",
                                     @"title": @"scratch4",
                                     @"paied": @(0)},
                                   @{@"image": @"scratch5",
                                     @"title": @"scratch5",
                                     @"paied": @(0)},
                                   nil];
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
