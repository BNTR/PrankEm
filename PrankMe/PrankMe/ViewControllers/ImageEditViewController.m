//
//  ImageEditViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 09.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "ImageEditViewController.h"
#import "CarouselItem.h"

@interface ImageEditViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) NSMutableArray *carouselItemsList;

@end

@implementation ImageEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSelectedImage:(UIImage *)selectedImage{
    self = [super initWithNibName:@"ImageEditViewController" bundle:nil];
    if (self) {
        self.selectedImage = selectedImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.image.image = self.selectedImage;
    self.navigationItem.title = @"Effects";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(goBackToGallery)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(goToShareScreen)];
    [self setupCarousel];
}

#pragma Navigation Buttons Action

- (void)goBackToGallery{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToShareScreen{
    NSLog(@"goToShareScreen");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Carousel Methods

- (void)setupCarousel{
    float xCoordinate = 0;
    
    UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shopButton.backgroundColor = [UIColor blueColor];
    UIImage *shopButtonImage = [UIImage imageNamed:@"shopButton"];
    [shopButton setImage:shopButtonImage forState:UIControlStateNormal];
    shopButton.frame = CGRectMake(0, 0, shopButtonImage.size.width, shopButtonImage.size.height);
    
    xCoordinate = shopButtonImage.size.width;
    
    UIImageView *separatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorImage"]];
    separatorImage.frame = CGRectMake(xCoordinate, 0, 28, 98);
    
    xCoordinate += separatorImage.frame.size.width;
    
    CarouselItem *item1 = [[[NSBundle mainBundle] loadNibNamed:@"CarouselItem"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
    [item1 setFrame:CGRectMake(xCoordinate, 0, item1.frame.size.width, item1.frame.size.height)];
    item1.itemImage.image = [UIImage imageNamed:@"image"];
    item1.itemLabel.text = @"Original";
    
    xCoordinate += item1.frame.size.width;
    
    self.carouselItemsList = [NSMutableArray arrayWithArray:@[shopButton, separatorImage, item1]];
    
    for (int i = 0; i < self.carouselItemsList.count; i++){
        [self.carousel addSubview:self.carouselItemsList[i]];
    }
    
    self.carousel.contentSize = CGSizeMake(self.carouselItemsList.count * 200, 94);
}

@end
