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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(goBackToGallery)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(goToShareScreen)];
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
    [item1.itemButton addTarget:self action:@selector(selectFilter) forControlEvents:UIControlEventTouchUpInside];
    
    xCoordinate += item1.frame.size.width;
    
    self.carouselItemsList = [NSMutableArray arrayWithArray:@[shopButton, separatorImage, item1]];
    
    for (int i = 0; i < self.carouselItemsList.count; i++){
        [self.carousel addSubview:self.carouselItemsList[i]];
    }
    
    self.carousel.contentSize = CGSizeMake(self.carouselItemsList.count * 200, 94);
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
