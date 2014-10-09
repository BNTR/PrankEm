//
//  BundleDetailViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 14.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "BundleDetailViewController.h"
#import "BundleDetailItem.h"
#import "BundleIAPHelper.h"

@interface BundleDetailViewController()

@property (nonatomic, strong) NSArray *bundle;
@property (nonatomic, strong) NSString *bundleTitle;
@property (nonatomic, strong) NSArray *overlays;
@property (nonatomic, strong) CarouselSourceSingleton *source;
@property (nonatomic) Group group;
@property (nonatomic) NSString *productID;
@property (nonatomic, strong) NSArray *products;

@end

@implementation BundleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithBundle:(NSArray *)bundle andBundleName:(NSString *)bundleName andGroup:(Group)group andProductIdentifire:(NSString *)productIdentifire{
    self = [super initWithNibName:@"BundleDetailViewController" bundle:nil];
    if (self) {
        self.bundle = bundle;
        self.bundleTitle = bundleName;
        self.group = group;
        self.productID = productIdentifire;
        self.source = [CarouselSourceSingleton sharedCarouselSourceSingleton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [self checkForHidePriceButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.navigationItem.title = @"Settings";
    
    UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shopButtonImage = [UIImage imageNamed:@"orangeShopButton"];
    shopButton.frame = CGRectMake(0, 0, shopButtonImage.size.width, shopButtonImage.size.height);
    [shopButton setBackgroundImage:shopButtonImage forState:UIControlStateNormal];
    [shopButton addTarget:self action:@selector(goBackToShop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shopButton];
    
    self.backgroundForOverlayPlace.backgroundColor = [UIColor clearColor];
    
    [self setupView];
}

- (void)setupView{
    self.overlays = self.bundle[0];
    int xCoor = 186;
    int yCoor = 26;
    int horizontalItemsCount = 0;
    for (int i = 0; i < self.overlays.count; i++){
        if (horizontalItemsCount == 2){
            horizontalItemsCount = 0;
            yCoor += 60;
        }
        if (i % 2 == 0){
            xCoor = 186;
        } else {
            xCoor = 250;
        }
        horizontalItemsCount++;
        BundleDetailItem *item = [[[NSBundle mainBundle] loadNibNamed:@"BundleDetailItem"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
        [item setFrame:CGRectMake(xCoor, yCoor, item.frame.size.width, item.frame.size.height)];
        item.selectedOverlay.image = [UIImage imageNamed:self.overlays[i][@"image"]];
        
        NSArray *color = [self getRGBAFromImage:item.selectedOverlay.image atx:593 atY:357];
        const CGFloat *colors = CGColorGetComponents([color[0] CGColor]);
        if (colors[0] < 0.07 && colors[1] < 0.07 && colors[2] < 0.07 && self.group == Spray){
            item.selectedOverlay.backgroundColor = [UIColor whiteColor];
        } else {
            item.selectedOverlay.backgroundColor = [UIColor blackColor];
        }

        UIButton *overlayShowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        overlayShowButton.frame = CGRectMake(xCoor, yCoor, item.frame.size.width, item.frame.size.height);
        [overlayShowButton addTarget:self action:@selector(showOverlay:) forControlEvents:UIControlEventTouchUpInside];
        overlayShowButton.tag = i;
        [self.view addSubview:item];
        [self.view addSubview:overlayShowButton];
    }
    self.effectsCount.text = [NSString stringWithFormat:@"%i effects", (int)self.overlays.count];
    self.bundleName.text = self.bundleTitle;
    
    NSString *productID = [self.source getProductIdByBundle:self.bundle];
    SKProduct *product = [self.source getProductById:productID];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
    self.price.text = formattedPrice;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)goBackToShop{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    NSString * productIdentifier = notification.object;
    [self.source bundlePurchasedWithId:productIdentifier andGroup:self.group];
    [self checkForHidePriceButton];
    [self.shopVC.tableView reloadData];
}

- (void)checkForHidePriceButton{
    if ([[BundleIAPHelper sharedInstance] productPurchased:self.productID]){
        self.price.hidden = YES;
        self.buyButton.hidden = YES;
        self.priceButtonBackground.hidden = YES;
    } else {
        self.price.hidden = NO;
        self.buyButton.hidden = NO;
        self.priceButtonBackground.hidden = NO;
    }
}

- (IBAction)buyBundle{
    SKProduct *product = [self.source getProductById:self.productID];
    [[BundleIAPHelper sharedInstance] buyProduct:product];
}

- (void)showOverlay:(UIButton *)sender{
    NSInteger tag = sender.tag;
    UIImage *selectedOverlay = [UIImage imageNamed:self.overlays[tag][@"image"]];
    // coors from all spray overlays contain this point with color
    NSArray *color = [self getRGBAFromImage:selectedOverlay atx:593 atY:357];
    const CGFloat *colors = CGColorGetComponents([color[0] CGColor]);
    if (colors[0] < 0.07 && colors[1] < 0.07 && colors[2] < 0.07 && self.group == Spray){
        self.backgroundForOverlayPlace.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundForOverlayPlace.backgroundColor = [UIColor blackColor];
    }
    self.selectedOverlay.image = selectedOverlay;
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
    //NSLog(@"width:%i hight:%i Color:%@",width,height,[color description]);
    free(rawData);
    return resultColor;
}

@end
