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

@property (nonatomic) IBOutlet UIButton *instagramButton;
@property (nonatomic) IBOutlet UIButton *facebookButton;
@property (nonatomic) IBOutlet UIButton *twitterButton;
@property (nonatomic) IBOutlet UIButton *mailButton;
@property (nonatomic) IBOutlet UIButton *textButton;

- (id)initWithCompleteImage:(UIImage *)completeImage;

@end
