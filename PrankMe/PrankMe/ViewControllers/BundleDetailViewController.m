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
    UIImage *shopButtonImage = [UIImage imageNamed:@"shopNavButton"];
    shopButton.frame = CGRectMake(0, 0, shopButtonImage.size.width, shopButtonImage.size.height);
    [shopButton setBackgroundImage:shopButtonImage forState:UIControlStateNormal];
    [shopButton addTarget:self action:@selector(goBackToShop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shopButton];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *emptyButtonNavImage = [UIImage imageNamed:@"emptyNavButton"];
    buyButton.frame = CGRectMake(0, 0, emptyButtonNavImage.size.width, emptyButtonNavImage.size.height);
    [buyButton setBackgroundImage:emptyButtonNavImage forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyBundle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buyButton];
    
    [self setupView];
}

- (void)setupView{
    self.overlays = self.bundle[0];
    int xCoor = 186;
    int yCoor = 26;
    for (int i = 0; i < self.overlays.count; i++){
        if (i % 2 == 0){
            xCoor = 186;
        } else {
            xCoor = 250;
        }
        BundleDetailItem *item = [[[NSBundle mainBundle] loadNibNamed:@"BundleDetailItem"
                                                            owner:self
                                                          options:nil] objectAtIndex:0];
        [item setFrame:CGRectMake(xCoor, yCoor, item.frame.size.width, item.frame.size.height)];
        item.selectedOverlay.image = [UIImage imageNamed:self.overlays[i][@"image"]];
        item.showOverlay.tag = i;
        [item.showOverlay addTarget:self action:@selector(showOverlay:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:item];
    }
    self.effectsCount.text = [NSString stringWithFormat:@"%i effects", (int)self.overlays.count];
    self.bundleName.text = self.bundleTitle;
    NSDictionary *price = self.bundle[1];
    self.price.text = price[@"price"];
    self.price.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14.035];
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
