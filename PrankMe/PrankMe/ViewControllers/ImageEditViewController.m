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
#import <QuartzCore/QuartzCore.h>

@interface ImageEditViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) FilterView *selectedFilter;

@property (nonatomic) CGPoint startLocation;
@property (nonatomic) BOOL dragging;
@property (nonatomic) BOOL rotating;

@property (nonatomic) float lastRotation;
@property (nonatomic) float lastScale;

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
    self.backgroundForImage.alpha = 0.2;
    
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
    NSLog(@"goToShareScreen");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Carousel Methods

- (void)setupCarousel{
    
//    NSArray *itemsList = @[@"shop",
//                           @{@"unlocked": @(1),
//                             @"filters":@[@{@"separator": @"separatorGlassImage"},
//                                          @{@"image": @"image1",
//                                            @"title": @"image1"
//                                            @"paied": @(1)},
//                                          @{@"image": @"image2",
//                                            @"title": @"image2"},
//                                          @{@"image": @"image3",
//                                            @"title": @"image3"}
//                                          ]
//                             },
//                           @{@"unlocked": @(0),
//                             @"filters":@[@{@"image": @"image1",
//                                            @"title": @"image1"},
//                                          @{@"image": @"image1",
//                                            @"title": @"image1"},
//                                          @{@"image": @"image2",
//                                            @"title": @"image2"},
//                                          @{@"image": @"image3",
//                                            @"title": @"image3"}]}
//                           
//                           ];
    
    
    float xCoordinate = 0;
    
    for (int i = 0; i < itemsList.count; i++){
        id item = [itemsList objectAtIndex:i];
        if ([item isKindOfClass:[NSString class]]){
            UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
            shopButton.backgroundColor = [UIColor blueColor];
            UIImage *shopButtonImage = [UIImage imageNamed:@"shopCarouselButton"];
            [shopButton setImage:shopButtonImage forState:UIControlStateNormal];
            shopButton.frame = CGRectMake(11, 0, shopButtonImage.size.width, shopButtonImage.size.height);
            xCoordinate +=shopButton.frame.size.width + 4;
            [self.carousel addSubview:shopButton];
        } else if ([item isKindOfClass:[NSDictionary class]]){
            NSDictionary *filters = [[NSDictionary alloc] initWithDictionary:item];
            BOOL unlocked = [[filters objectForKey:@"unlocked"] boolValue];
            if (unlocked){
                NSArray *filtersItems = [filters objectForKey:@"filters"];
                for (int j = 0; j < filtersItems.count; j++){
                    NSDictionary *item = [[NSDictionary alloc] initWithDictionary:filtersItems[j]];
                    NSLog(@"%@, %@", [item objectForKey:@"image"], [item objectForKey:@"title"]);
                }
            }
        }
    }
    
//    UIImageView *separatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorImage"]];
//    separatorImage.frame = CGRectMake(xCoordinate, 0, 28, 98);
//    
//    xCoordinate += separatorImage.frame.size.width;
//    
//    CarouselItem *item1 = [[[NSBundle mainBundle] loadNibNamed:@"CarouselItem"
//                                                         owner:self
//                                                       options:nil] objectAtIndex:0];
//    [item1 setFrame:CGRectMake(xCoordinate, 0, item1.frame.size.width, item1.frame.size.height)];
//    item1.itemImage.image = [UIImage imageNamed:@"image"];
//    item1.itemLabel.text = @"Original";
//    [item1.itemButton addTarget:self action:@selector(selectFilter) forControlEvents:UIControlEventTouchUpInside];
//    
//    xCoordinate += item1.frame.size.width;
//    
//    self.carouselItemsList = [NSMutableArray arrayWithArray:@[shopButton, separatorImage, item1]];
//    
//    for (int i = 0; i < self.carouselItemsList.count; i++){
//        [self.carousel addSubview:self.carouselItemsList[i]];
//    }
//    
//    self.carousel.contentSize = CGSizeMake(self.carouselItemsList.count * 200, 94);
}

#pragma mark Select Filter 

- (void)selectFilter{
    self.selectedFilter = [[[NSBundle mainBundle] loadNibNamed:@"FilterView"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
    [self.selectedFilter setFrame:CGRectMake(0, 0, self.selectedFilter.frame.size.width, self.selectedFilter.frame.size.height)];
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

@end
