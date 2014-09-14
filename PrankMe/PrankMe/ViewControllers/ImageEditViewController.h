//
//  ImageEditViewController.h
//  PrankMe
//
//  Created by VIktor Sokolov on 09.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageEditViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic) IBOutlet UIScrollView *carousel;

- (id)initWithSelectedImage:(UIImage *)selectedImage;

@end
