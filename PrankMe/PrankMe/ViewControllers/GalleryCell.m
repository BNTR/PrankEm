//
//  GalleryCell.m
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "GalleryCell.h"

@interface GalleryCell ()

@property (nonatomic, weak) IBOutlet UIImageView *itemImage;

@end

@implementation GalleryCell

- (void) setAsset:(ALAsset *)asset
{
    _asset = asset;
    self.itemImage.image = [UIImage imageWithCGImage:[asset thumbnail]];
}

@end
