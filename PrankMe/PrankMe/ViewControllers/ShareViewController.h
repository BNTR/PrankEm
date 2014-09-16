//
//  ShareViewController.h
//  PrankMe
//
//  Created by VIktor Sokolov on 16.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController

@property (nonatomic) IBOutlet UIImageView *completeImageView;

- (id)initWithCompleteImage:(UIImage *)completeImage;

@end
