//
//  ImageEditViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 09.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "ImageEditViewController.h"
#import "CarouselItem.h"
#import "FilterView.h"
#import "CarouselSourceSingleton.h"
#import "ShopViewController.h"
#import "ShareViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageEditViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) FilterView *selectedFilter;

@property (nonatomic) CGPoint startLocation;
@property (nonatomic) BOOL dragging;
@property (nonatomic) BOOL rotating;

@property (nonatomic) float lastRotation;
@property (nonatomic) float lastScale;

@property (nonatomic, strong) CarouselSourceSingleton *carouselSource;
@property (nonatomic, strong) NSString *selectedLayerName;

@end

@implementation ImageEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithSelectedImage:(UIImage *)selectedImage{
    self = [super initWithNibName:@"ImageEditViewController" bundle:nil];
    if (self) {
        self.selectedImage = selectedImage;
        self.carouselSource = [CarouselSourceSingleton sharedCarouselSourceSingleton];
        self.carouselContent = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.image.image = self.selectedImage;
    self.navigationItem.title = @"Effects";
    self.navigationController.delegate = self;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelButtonImage = [UIImage imageNamed:@"cancelButton"];
    cancelButton.frame = CGRectMake(0, 0, cancelButtonImage.size.width, cancelButtonImage.size.height);
    [cancelButton setBackgroundImage:cancelButtonImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(goBackToGallery) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *applyButtonImage = [UIImage imageNamed:@"applyButton"];
    applyButton.frame = CGRectMake(0, 0, applyButtonImage.size.width, applyButtonImage.size.height);
    [applyButton setBackgroundImage:applyButtonImage forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(goToShareScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:applyButton];
    
    [self setupCarousel];
    self.rotating = NO;
}

#pragma Navigation Buttons Action

- (void)goBackToGallery{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToShareScreen{
    CGSize newSize = CGSizeMake(self.selectedImage.size.width, self.selectedImage.size.height);
    UIGraphicsBeginImageContext(newSize);
    
    [self.selectedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    [self.selectedFilter.filterImage.image drawInRect:CGRectMake(self.selectedFilter.filterImage.frame.origin.x,
                                                                 self.selectedFilter.filterImage.frame.origin.y,
                                                                 self.selectedFilter.filterImage.frame.size.width,
                                                                 self.selectedFilter.filterImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //[self.view addSubview:[[UIImageView alloc] initWithImage:mergedImage]];
    ShareViewController *shareVC = [[ShareViewController alloc] initWithCompleteImage:mergedImage];
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Carousel Methods

- (void)reloadCarousel{
    [self.carouselContent removeFromSuperview];
    self.carouselContent = nil;
    [self setupCarousel];
}

- (void)setupCarousel{
    if (self.carouselContent == nil){
        self.carouselContent = [[UIView alloc] init];
    }
    NSArray *itemsList = [self.carouselSource getAllItems];
    
    float xCoordinate = 0;
    
    UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shopButton.backgroundColor = [UIColor blueColor];
    UIImage *shopButtonImage = [UIImage imageNamed:@"shopCarouselButton"];
    [shopButton setImage:shopButtonImage forState:UIControlStateNormal];
    shopButton.frame = CGRectMake(11, 0, shopButtonImage.size.width, shopButtonImage.size.height);
    [shopButton addTarget:self action:@selector(goToShop:) forControlEvents:UIControlEventTouchUpInside];
    xCoordinate +=shopButton.frame.size.width + shopButton.frame.origin.x + 4;
    [self.carouselContent addSubview:shopButton];
    
    for (int i = 0; i < itemsList.count; i++){
        NSArray *group = itemsList[i];
        for (int j = 0; j < group.count; j++){
            NSDictionary *filters = [group objectAtIndex:j];
            if (j == 0){
                UIImage *separatorImage = [UIImage imageNamed:filters[@"image"]];
                UIImageView *separatorImageView = [[UIImageView alloc] initWithImage:separatorImage];
                separatorImageView.frame = CGRectMake(xCoordinate, 0, separatorImage.size.width, separatorImage.size.height);
                [self.carouselContent addSubview:separatorImageView];
                xCoordinate += separatorImageView.frame.size.width + 4;
            } else {
                CarouselItem *item = [[[NSBundle mainBundle] loadNibNamed:@"CarouselItem"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
                [item setFrame:CGRectMake(xCoordinate, 0, item.frame.size.width, item.frame.size.height)];
                item.itemImage.image = [UIImage imageNamed:filters[@"image"]];
                item.itemLabel.text = filters[@"title"];
                item.itemLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:11.765];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFilter:)];
                [item addGestureRecognizer:tap];
                [self.carouselContent addSubview:item];
                xCoordinate +=item.frame.size.width + 4;
            }
        }
    }
    self.carouselContent.frame = CGRectMake(0, 0, xCoordinate, 94);
    [self.carousel addSubview:self.carouselContent];
    self.carousel.contentSize = CGSizeMake(xCoordinate, 94);
}

#pragma mark Select Filter 

- (void)selectFilter:(UITapGestureRecognizer *)recognizer{
    CarouselItem *selecteLayer = (CarouselItem *)recognizer.view;
    self.selectedFilter = [[[NSBundle mainBundle] loadNibNamed:@"FilterView"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
    [self.selectedFilter setFrame:CGRectMake(0, 0, self.selectedFilter.frame.size.width, self.selectedFilter.frame.size.height)];
    self.selectedFilter.filterImage.image = selecteLayer.itemImage.image;
    [self.image addSubview:self.selectedFilter];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer setDelegate:self];
	[self.view addGestureRecognizer:rotationRecognizer];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[pinchRecognizer setDelegate:self];
	[self.view addGestureRecognizer:pinchRecognizer];
}

#pragma mark Move Selected Filter

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint translation = [panRecognizer translationInView:self.view];
    CGPoint imageViewPosition = self.selectedFilter.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.selectedFilter.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self.view];
}

-(void)scale:(id)sender {
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = self.selectedFilter.filterImage.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.selectedFilter.filterImage setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.selectedFilter.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self.selectedFilter setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (IBAction)goToShop:(id)sender{
    ShopViewController *shopVC = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    shopVC.imageEdit = self;
    [self.navigationController pushViewController:shopVC animated:YES];
}

@end
