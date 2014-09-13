//
//  ShopItemCell.m
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "ShopItemCell.h"

@implementation ShopItemCell

- (void)awakeFromNib
{
    self.itemTopLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18.0];
    self.itemBottomLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
