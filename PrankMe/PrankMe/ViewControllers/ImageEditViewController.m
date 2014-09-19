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
#import "ZDStickerView.h"
#import "OverlayOptions.h"
#import "UIImage+Filtering.h"

@interface ImageEditViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, ZDStickerViewDelegate>

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) FilterView *selectedFilter;
@property (nonatomic, strong) CarouselSourceSingleton *carouselSource;
@property (nonatomic, strong) NSMutableArray *overlaysOnScreen;
@property (nonatomic, strong) OverlayOptions *overlayOptions;

@property (nonatomic, strong) UIImage *originalOverlayImage;

@property (nonatomic, strong) UIView *selectedImageTopView;
@end

#import <CoreImage/CoreImage.h>

@interface UIImage (ColorInverse)

@end


@implementation UIImage (ColorInverse)

+ (UIImage *)inverseColor:(UIImage *)image
{
    CIImage *coreImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:coreImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    return [UIImage imageWithCIImage:result];
}

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
        self.overlaysOnScreen = [NSMutableArray array];
        self.selectedImageTopView = [[UIView alloc] init];
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
    //self.selectedImageTopView.backgroundColor = [UIColor redColor];
    
    CGSize size = [self imageSizeAfterAspectFit:self.image];
    self.selectedImageTopView.frame = CGRectMake(self.image.frame.origin.x, self.image.frame.origin.y, size.width, size.height);
    self.selectedImageTopView.clipsToBounds = YES;
    [self.view addSubview:self.selectedImageTopView];
    [self setupCarousel];
}

-(CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview{
    float newwidth;
    float newheight;
    
    UIImage *image = imgview.image;
    
    if (image.size.height >= image.size.width){
        newheight = imgview.frame.size.height;
        newwidth = (image.size.width/image.size.height)*newheight;
        
        if (newwidth > imgview.frame.size.width){
            float diff = imgview.frame.size.width-newwidth;
            newheight = newheight+diff/newheight*newheight;
            newwidth = imgview.frame.size.width;
        }
        
    }
    else{
        newwidth = imgview.frame.size.width;
        newheight = (image.size.height/image.size.width)*newwidth;
        
        if(newheight > imgview.frame.size.height){
            float diff = imgview.frame.size.height-newheight;
            newwidth = newwidth+diff/newwidth*newwidth;
            newheight = imgview.frame.size.height;
        }
    }
    
    NSLog(@"image after aspect fit: width=%f height=%f",newwidth,newheight);
    
    
    //adapt UIImageView size to image size
    imgview.frame=CGRectMake(imgview.frame.origin.x+(imgview.frame.size.width-newwidth)/2,imgview.frame.origin.y+(imgview.frame.size.height-newheight)/2,newwidth,newheight);
    
    return CGSizeMake(newwidth, newheight);
}

#pragma Navigation Buttons Action

- (void)goBackToGallery{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToShareScreen{
    UIImage *image = self.image.image;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyImageName.png"];
    
    // Convert UIImage object into NSData (a wrapper for a stream of bytes) formatted according to PNG spec
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
    
    ShareViewController *shareVC = [[ShareViewController alloc] initWithCompleteImage:self.image.image];
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


- (IBAction)goToShop:(id)sender{
    ShopViewController *shopVC = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    shopVC.imageEdit = self;
    [self.navigationController pushViewController:shopVC animated:YES];
}

#pragma mark Select Filter 

- (void)selectFilter:(UITapGestureRecognizer *)recognizer{
    CarouselItem *selecteLayer = (CarouselItem *)recognizer.view;
    [self showOverlayOptionsForImage:selecteLayer.itemImage.image];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:selecteLayer.itemImage.image];
    CGRect gripFrame1 = CGRectMake(50, 50, 140, 140);
    imageView1.frame = gripFrame1;
    UIView* contentView = [[UIView alloc] initWithFrame:gripFrame1];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView addSubview:imageView1];
    
    ZDStickerView *overlay = [[ZDStickerView alloc] initWithFrame:gripFrame1];
    overlay.tag = 0;
    overlay.delegate = self;
    overlay.contentView = contentView;
    overlay.preventsPositionOutsideSuperview = NO;
    overlay.preventsCustomButton = NO;
    [overlay setButton:ZDSTICKERVIEW_BUTTON_CUSTOM
                            image:[UIImage imageNamed:@"rotateOverlayButton"]];
    [overlay showEditingHandles];

    [self.selectedImageTopView addSubview:overlay];
    [self.overlaysOnScreen addObject:overlay];
    [self addApplyButton];
}

- (void)addApplyButton{
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *applyButtonImage = [UIImage imageNamed:@"applyButton"];
    applyButton.frame = CGRectMake(0, 0, applyButtonImage.size.width, applyButtonImage.size.height);
    [applyButton setBackgroundImage:applyButtonImage forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(useFilter) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:applyButton];
}

- (void)useFilter{
    [self hideAllOverlaysInterfaces];
    
    self.image.image = [self buildImage:self.image.image];
    [self deleteAllOverlays];
    [self.overlaysOnScreen removeAllObjects];
    
    self.overlayOptions.hidden = YES;
    self.carouselContent.hidden = NO;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *doneButtonImage = [UIImage imageNamed:@"doneButton"];
    doneButton.frame = CGRectMake(0, 0, doneButtonImage.size.width, doneButtonImage.size.height);
    [doneButton setBackgroundImage:doneButtonImage forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(goToShareScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
}

- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / self.selectedImageTopView.frame.size.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [self.selectedImageTopView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (void)hideAllOverlaysInterfaces{
    for (int i = 0; i < self.overlaysOnScreen.count; i++){
        ZDStickerView *overlay = self.overlaysOnScreen[i];
        [overlay hideCustomHandle];
        [overlay hideDelHandle];
        [overlay hideEditingHandles];
    }
}

- (void)deleteAllOverlays{
    for (int i = 0; i < self.overlaysOnScreen.count; i++){
        ZDStickerView *overlay = self.overlaysOnScreen[i];
        [overlay removeFromSuperview];
    }
}

- (void)stickerViewDidClose:(ZDStickerView *)sticker{
    [self.overlaysOnScreen removeObject:sticker];
    self.overlayOptions.hidden = YES;
    self.carouselContent.hidden = NO;
}

#pragma mark Overlay Options

- (void)showOverlayOptionsForImage:(UIImage *)image{
    self.overlayOptions = [[[NSBundle mainBundle] loadNibNamed:@"OverlayOptions"
                                                        owner:self
                                                      options:nil] objectAtIndex:0];
    [self.overlayOptions setFrame:CGRectMake(0,
                                             self.carousel.frame.origin.y,
                                             self.overlayOptions.frame.size.width,
                                             self.overlayOptions.frame.size.height)];
    [self.overlayOptions.brightnessSlider addTarget:self action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
    [self.overlayOptions.contrastSlider addTarget:self action:@selector(contrastChanged:) forControlEvents:UIControlEventValueChanged];
    [self.overlayOptions.invertColorButton addTarget:self action:@selector(invertColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.overlayOptions];
    self.originalOverlayImage = image;
    self.carouselContent.hidden = YES;
}

- (IBAction)brightnessChanged:(UISlider *)sender{
    ZDStickerView *overlay = self.overlaysOnScreen[0];
    UIView *content = overlay.contentView;
    UIImageView *overlayImage = [[UIImageView alloc] init];
    for (int j = 0; j < content.subviews.count; j++){
        if ([content.subviews[j] isKindOfClass:[UIImageView class]]){
            overlayImage = content.subviews[j];
        }
    }
    overlayImage.image = [self.originalOverlayImage brightenWithValue:sender.value];
}

- (IBAction)contrastChanged:(UISlider *)sender{
    ZDStickerView *overlay = self.overlaysOnScreen[0];
    UIView *content = overlay.contentView;
    UIImageView *overlayImage = [[UIImageView alloc] init];
    for (int j = 0; j < content.subviews.count; j++){
        if ([content.subviews[j] isKindOfClass:[UIImageView class]]){
            overlayImage = content.subviews[j];
        }
    }
   overlayImage.image = [self.originalOverlayImage contrastAdjustmentWithValue:sender.value];
}

- (IBAction)invertColor:(id)sender{
    ZDStickerView *overlay = self.overlaysOnScreen[0];
    UIView *content = overlay.contentView;
    UIImageView *overlayImage = [[UIImageView alloc] init];
    for (int j = 0; j < content.subviews.count; j++){
        if ([content.subviews[j] isKindOfClass:[UIImageView class]]){
            overlayImage = content.subviews[j];
        }
    }
    UIGraphicsBeginImageContext(overlayImage.image.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    CGRect imageRect = CGRectMake(0, 0, overlayImage.image.size.width, overlayImage.image.size.height);
    [overlayImage.image drawInRect:imageRect];
    
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, overlayImage.image.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    //mask the image
    CGContextClipToMask(UIGraphicsGetCurrentContext(), imageRect,  overlayImage.image.CGImage);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, overlayImage.image.size.width, overlayImage.image.size.height));
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    overlayImage.image = returnImage;
    self.originalOverlayImage = returnImage;
}

@end
