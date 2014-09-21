//
//  BundleDetailViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 14.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "BundleDetailViewController.h"
#import "BundleDetailItem.h"

@interface BundleDetailViewController()

@property (nonatomic, strong) NSArray *bundle;
@property (nonatomic, strong) NSString *bundleTitle;
@property (nonatomic, strong) NSArray *overlays;
@property (nonatomic, strong) CarouselSourceSingleton *source;
@property (nonatomic) Group group;

@end

@implementation BundleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithBundle:(NSArray *)bundle andBundleName:(NSString *)bundleName andGroup:(Group)group{
    self = [super initWithNibName:@"BundleDetailViewController" bundle:nil];
    if (self) {
        self.bundle = bundle;
        self.bundleTitle = bundleName;
        self.group = group;
        self.source = [CarouselSourceSingleton sharedCarouselSourceSingleton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.navigationItem.title = @"Settings";
    
    UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shopButtonImage = [UIImage imageNamed:@"orangeShopButton"];
    shopButton.frame = CGRectMake(0, 0, shopButtonImage.size.width, shopButtonImage.size.height);
    [shopButton setBackgroundImage:shopButtonImage forState:UIControlStateNormal];
    [shopButton addTarget:self action:@selector(goBackToShop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shopButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *orangeDoneImage = [UIImage imageNamed:@"orangeDoneButton"];
    doneButton.frame = CGRectMake(0, 0, orangeDoneImage.size.width, orangeDoneImage.size.height);
    [doneButton setBackgroundImage:orangeDoneImage forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(goBackToShop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
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
        UIButton *overlayShowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        overlayShowButton.frame = CGRectMake(xCoor, yCoor, item.frame.size.width, item.frame.size.height);
        [overlayShowButton addTarget:self action:@selector(showOverlay:) forControlEvents:UIControlEventTouchUpInside];
        overlayShowButton.tag = i;
        [self.view addSubview:item];
        [self.view addSubview:overlayShowButton];
    }
    self.effectsCount.text = [NSString stringWithFormat:@"%i effects", (int)self.overlays.count];
    self.bundleName.text = self.bundleTitle;
    NSDictionary *price = self.bundle[1];
    self.price.text = price[@"price"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)goBackToShop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyBundle{
    switch (self.group) {
        case BrokenGlass:{
            [self.source.brokenGlassFilters addObjectsFromArray:self.bundle[0]];
            break;
        }
        case Scratches:{
            [self.source.scratchesFilters addObjectsFromArray:self.bundle[0]];
            break;
        }
        default:
            break;
    }
}

- (void)showOverlay:(UIButton *)sender{
    NSInteger tag = sender.tag;
    self.selectedOverlay.image = [UIImage imageNamed:self.overlays[tag][@"image"]];
}

@end
