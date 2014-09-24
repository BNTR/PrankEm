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
                                   @{@"image": @"glassFree1",
                                     @"title": @"glassFree1"},
                                   @{@"image": @"glassFree2",
                                     @"title": @"glassFree2"},
                                   nil];
        self.brokenGlassFirstBundle = [NSMutableArray arrayWithObjects:
                                       @[
                                       @{@"image": @"glassBundle1_1",
                                         @"title": @"glassBundle1_1"},
                                       @{@"image": @"glassBundle1_2",
                                         @"title": @"glassBundle1_2",},
                                       @{@"image": @"glassBundle1_3",
                                         @"title": @"glassBundle1_3"}
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
                                   @{@"image": @"glassSeparator"},
                                   @{@"image": @"scratchFree1",
                                     @"title": @"scratchFree1"},
                                   @{@"image": @"scratchFree2",
                                     @"title": @"scratchFree2"},
                                   nil];
        
        self.scratchesGlassFirstBundle = [NSMutableArray arrayWithObjects:
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
        self.scratchesGlassSecondBundle = [NSMutableArray arrayWithObjects:
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
        
        self.allScratchesBundles = [NSMutableArray arrayWithObjects:self.scratchesGlassFirstBundle, self.scratchesGlassSecondBundle, nil];
        
        self.spreyFilters = [NSMutableArray arrayWithObjects:
                                 @{@"image": @"glassSeparator"},
                                 @{@"image": @"spreyFree1",
                                   @"title": @"spreyFree1"},
                                 @{@"image": @"spreyFree2",
                                   @"title": @"spreyFree2"},
                                 @{@"image": @"spreyFree3",
                                   @"title": @"spreyFree3"},
                                 @{@"image": @"spreyFree4",
                                   @"title": @"spreyFree4"},
                                 @{@"image": @"spreyFree5",
                                   @"title": @"spreyFree5"},
                                 @{@"image": @"spreyFree6",
                                   @"title": @"spreyFree6"},
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
        case Sprey:
        {
            NSDictionary *items = [self.spreyFilters objectAtIndex:index];
            [items setValue:@(1) forKey:@"paied"];
            break;
        }
        default:
            break;
    }
}

- (NSArray *)getAllItems{
    return @[self.brokenGlassFilters, self.scratchesFilters, self.spreyFilters];
}

- (NSInteger)getAllItemsCount{
    return self.brokenGlassFilters.count + self.scratchesFilters.count + self.spreyFilters.count;
}

@end
