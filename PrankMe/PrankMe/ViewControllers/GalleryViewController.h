//
//  GalleryViewController.h
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView *pictures;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic) IBOutlet UIButton *cameraButton;
@property (nonatomic) IBOutlet UIButton *rollButton;
@property (nonatomic, strong) NSArray *imagesFromRoll;

@end
