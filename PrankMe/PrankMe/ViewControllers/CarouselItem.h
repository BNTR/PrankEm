//
//  CarouselItem.h
//  PrankMe
//
//  Created by VIktor Sokolov on 10.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselItem : UIView

@property (nonatomic, strong) IBOutlet UIImageView *itemImage;
@property (nonatomic, strong) IBOutlet UILabel *itemLabel;

@end
