//
//  OverlayOptions.h
//  PrankMe
//
//  Created by VIktor Sokolov on 18.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayOptions : UIView

@property (nonatomic) IBOutlet UILabel *brightnessLabel;
@property (nonatomic) IBOutlet UISlider *brightnessSlider;
@property (nonatomic) IBOutlet UILabel *contrastLabel;
@property (nonatomic) IBOutlet UISlider *contrastSlider;
@property (nonatomic) IBOutlet UILabel *invertLabel;
@property (nonatomic) IBOutlet UIButton *invertColorButton;
@property (nonatomic) IBOutlet UIImageView *invertColorImage;

@end
