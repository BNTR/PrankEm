//
//  BundleDetailViewController.h
//  PrankMe
//
//  Created by VIktor Sokolov on 14.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarouselSourceSingleton.h"
#import "ShopViewController.h"

@interface BundleDetailViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *bundleName;
@property (nonatomic) IBOutlet UILabel *effectsCount;
@property (nonatomic) IBOutlet UIImageView *selectedOverlay;
@property (nonatomic) IBOutlet UILabel *price;
@property (nonatomic) IBOutlet UIImageView *priceButtonBackground;
@property (nonatomic) IBOutlet UIButton *buyButton;
@property (nonatomic) IBOutlet UIView *backgroundForOverlayPlace;
@property (nonatomic, weak) ShopViewController *shopVC;

- (id)initWithBundle:(NSArray *)bundle andBundleName:(NSString *)bundleName andGroup:(Group)group andProductIdentifire:(NSString *)productIdentifire;

@end
