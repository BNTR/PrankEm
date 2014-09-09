//
//  ShopItemCell.h
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopItemCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *itemImage;
@property (nonatomic) IBOutlet UILabel *itemTopLabel;
@property (nonatomic) IBOutlet UILabel *itemBottomLabel;
@property (nonatomic) IBOutlet UIButton *itemButton;

@end
