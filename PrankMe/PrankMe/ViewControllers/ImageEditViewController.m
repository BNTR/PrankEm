//
//  ImageEditViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 09.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "ImageEditViewController.h"
#import "CarouselItem.h"
#import "CarouselSourceSingleton.h"
#import "ShopViewController.h"
#import "ShareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZDStickerView.h"
#import "OverlayOptions.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+Filtering.h"

@interface ImageEditViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, ZDStickerViewDelegate>

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) CarouselSourceSingleton *carouselSource;
@property (nonatomic, strong) NSMutableArray *overlaysOnScreen;
@property (nonatomic, strong) OverlayOptions *overlayOptions;
@property (nonatomic) BOOL invertOn;

@property (nonatomic, strong) UIImage *originalOverlayImage;
@property (nonatomic, strong) UIImage *overlayImageForOptions;

@property (nonatomic, strong) UIView *selectedImageTopView;
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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
             self = [super initWithNibName:@"ImageEditViewController" bundle:nil];
        }
        if(result.height == 568)
        {
             self = [super initWithNibName:@"ImageEditViewControllerIphone5" bundle:nil];
        }
    }
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
                UIImage *originalImage = [UIImage imageNamed:filters[@"image"]];
                item.originalImageName = filters[@"image"];
                
                NSArray *color = [self getRGBAFromImage:originalImage atx:593 atY:357];
                const CGFloat *colors = CGColorGetComponents([color[0] CGColor]);
                if (colors[0] < 0.07 && colors[1] < 0.07 && colors[2] < 0.07 && i == Spray){
                    item.itemImage.backgroundColor = [UIColor whiteColor];
                } else {
                    item.itemImage.backgroundColor = [UIColor blackColor];
                }
                
                CGSize destinationSize = CGSizeMake(96, 96);
                UIGraphicsBeginImageContext(destinationSize);
                [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                item.itemImage.image = thumbImage;
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
    self.navigationItem.title = selecteLayer.itemLabel.text;
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:selecteLayer.originalImageName]];
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
    [overlay showEditingHandles];

    [self.selectedImageTopView addSubview:overlay];
    [self.overlaysOnScreen addObject:overlay];
    [self addApplyButton];
    self.invertOn = NO;
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
    self.navigationItem.title = @"Effects";
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *doneButtonImage = [UIImage imageNamed:@"doneButton"];
    doneButton.frame = CGRectMake(0, 0, doneButtonImage.size.width, doneButtonImage.size.height);
    [doneButton setBackgroundImage:doneButtonImage forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(goToShareScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
}

- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, self.image.image.scale);
    
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
    self.navigationItem.title = @"Effects";
}

#pragma mark Overlay Options

- (void)showOverlayOptionsForImage:(UIImage *)image{
    self.overlayOptions = [[[NSBundle mainBundle] loadNibNamed:@"OverlayOptions"
                                                        owner:self
                                                      options:nil] objectAtIndex:0];
    [self.overlayOptions setFrame:CGRectMake(0,
                                             self.view.frame.size.height - self.overlayOptions.frame.size.height,
                                             self.overlayOptions.frame.size.width,
                                             self.overlayOptions.frame.size.height)];
    [self.overlayOptions.brightnessSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.overlayOptions.contrastSlider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.overlayOptions.invertColorButton addTarget:self action:@selector(invertColor:) forControlEvents:UIControlEventTouchUpInside];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateHighlighted];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateSelected];
    [self.view addSubview:self.overlayOptions];
    self.originalOverlayImage = image;
    self.overlayImageForOptions = image;
    self.carouselContent.hidden = YES;
}

- (void)sliderDidChange:(UISlider*)sender
{
    ZDStickerView *overlay = self.overlaysOnScreen[0];
    UIView *content = overlay.contentView;
    UIImageView *overlayImage = [[UIImageView alloc] init];
    for (int j = 0; j < content.subviews.count; j++){
        if ([content.subviews[j] isKindOfClass:[UIImageView class]]){
            overlayImage = content.subviews[j];
        }
    }

    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:self.overlayImageForOptions];
        [overlayImage performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

- (UIImage*)filteredImage:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat brightness = 2 * self.overlayOptions.brightnessSlider.value;
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputEV"];
    
    filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat contrast   = self.overlayOptions.contrastSlider.value * self.overlayOptions.contrastSlider.value;
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputPower"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

- (IBAction)invertColor:(id)sender{
    if (self.invertOn){
        self.overlayOptions.invertColorImage.image = [UIImage imageNamed:@"invertColorUncheck"];
        self.invertOn = NO;
        self.overlayImageForOptions = self.originalOverlayImage;
        ZDStickerView *overlay = self.overlaysOnScreen[0];
        UIView *content = overlay.contentView;
        UIImageView *overlayImage = [[UIImageView alloc] init];
        for (int j = 0; j < content.subviews.count; j++){
            if ([content.subviews[j] isKindOfClass:[UIImageView class]]){
                overlayImage = content.subviews[j];
            }
        }
        overlayImage.image = self.originalOverlayImage;
        self.overlayOptions.brightnessSlider.value = 0.0;
        self.overlayOptions.contrastSlider.value = 1.0;
    } else {
        self.overlayOptions.invertColorImage.image = [UIImage imageNamed:@"invertColorCheck"];
        self.invertOn = YES;
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
        self.overlayImageForOptions = returnImage;
    }
}

- (NSArray*)getRGBAFromImage:(UIImage*)image atx:(int)xp atY:(int)yp{
    NSMutableArray *resultColor = [NSMutableArray array];
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    
    int byteIndex = (bytesPerRow * yp) + xp * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) /255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0)/255.0 ;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0)/255.0 ;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) /255.0;
    byteIndex += 4;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    [resultColor addObject:color];
    NSLog(@"width:%i hight:%i Color:%@",width,height,[color description]);
    free(rawData);
    return resultColor;
}


@end
