//
//  ShopViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopItemCell.h"
#import "BundleDetailViewController.h"
#import "CarouselSourceSingleton.h"
#import "BundleIAPHelper.h"

@interface ShopViewController ()<UITableViewDataSource, UITableViewDelegate>
    
@property (nonatomic, strong) CarouselSourceSingleton *carouselSource;
@property (nonatomic, strong) BundleDetailViewController *bundleVC;

@property (nonatomic) Group group;

@property (strong, nonatomic) IBOutlet UIView *segmentControlView;

@end

@implementation ShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.carouselSource = [CarouselSourceSingleton sharedCarouselSourceSingleton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productRestored:) name:IAPHelperProductRestoredNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAfterProductsArrived) name:IAPHelperProductsArrivedNotification object:nil];
    
    self.navigationItem.title = @"Supply Shop";
    
    UIButton *restoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *restoreButtonImage = [UIImage imageNamed:@"restoreButton"];
    restoreButton.frame = CGRectMake(0, 0, restoreButtonImage.size.width, restoreButtonImage.size.height);
    [restoreButton setBackgroundImage:restoreButtonImage forState:UIControlStateNormal];
    [restoreButton addTarget:self action:@selector(restoreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:restoreButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *doneButtonImage = [UIImage imageNamed:@"doneButton"];
    doneButton.frame = CGRectMake(0, 0, doneButtonImage.size.width, doneButtonImage.size.height);
    [doneButton setBackgroundImage:doneButtonImage forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    self.effectsLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma Navigation Buttons Action

- (void)restoreButtonTapped{
    [[BundleIAPHelper sharedInstance] restoreCompletedTransactions];
}

- (void)doneButtonTapped{
    [self.imageEdit reloadCarousel];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductsArrivedNotification object:nil];
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *bundle = [NSMutableArray array];
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            bundle = self.carouselSource.allBrokenGlassBundles[indexPath.row];
            break;
        }
        case 1:{
            bundle = self.carouselSource.allScratchesBundles[indexPath.row];
            break;
        }
        case 2:{
            bundle = self.carouselSource.allSprayBundles[indexPath.row];
            break;
        }
        default:
            break;
    }
    NSString *productID = [self.carouselSource getProductIdByBundle:bundle];
    SKProduct *product = [self.carouselSource getProductById:productID];
    self.bundleVC = [[BundleDetailViewController alloc] initWithBundle:bundle
                                                         andBundleName:product.localizedTitle
                                                              andGroup:self.group
                                                  andProductIdentifire:productID];
    self.bundleVC.shopVC = self;
    [self.navigationController pushViewController:self.bundleVC animated:YES];
}

#pragma mark Table View Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            return self.carouselSource.allBrokenGlassBundles.count;
            break;
        }
        case 1:
            return self.carouselSource.allScratchesBundles.count;
            break;
        case 2:
            return self.carouselSource.allSprayBundles.count;
            break;
        default:{
            return 0;
            break;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ShopCell";
    ShopItemCell *cell = (ShopItemCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSMutableArray *bundle = [NSMutableArray array];
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            bundle = self.carouselSource.allBrokenGlassBundles[indexPath.row];
            break;
        }
        case 1:{
            bundle = self.carouselSource.allScratchesBundles[indexPath.row];
            break;
        }
        case 2:{
            bundle = self.carouselSource.allSprayBundles[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    cell.itemImage.image = [UIImage imageNamed:@"sampleFilterImage"];
    
    NSString *productID = [self.carouselSource getProductIdByBundle:bundle];
    SKProduct *product = [self.carouselSource getProductById:productID];
    if ([[BundleIAPHelper sharedInstance] productPurchased:productID]){
        cell.itemPriceLabel.text = @"Bought";
    } else {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
        cell.itemPriceLabel.text = formattedPrice;
    }
    cell.itemTopLabel.text = [NSString stringWithFormat:@"%@", product.localizedTitle];
    NSArray *effects = bundle[0];
    cell.itemBottomLabel.text = [NSString stringWithFormat:@"%i effects", (int)effects.count];
    cell.itemPriceLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14.035];
    [cell.itemButton setTag:indexPath.row];
    [cell.itemButton addTarget:self action:@selector(buyFilters:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 320, 81.0)];
    UIView *backgroundLine = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 320, 81.0)];
    backgroundLine.backgroundColor = [UIColor whiteColor];
    backgroundLine.alpha = 0.2;
    [background addSubview:backgroundLine];
    cell.backgroundView = background;

    return cell;
}

- (IBAction)buyFilters:(UIButton *)sender{
    NSMutableArray *bundle = [NSMutableArray array];
    switch (self.segmentControl.selectedSegmentIndex) {
        case BrokenGlass:{
            bundle = self.carouselSource.allBrokenGlassBundles[sender.tag];
            break;
        }
        case Scratches:{
            bundle = self.carouselSource.allScratchesBundles[sender.tag];
            break;
        }
        case Spray:{
            bundle = self.carouselSource.allSprayBundles[sender.tag];
            break;
        }
        default:
            break;
    }
    NSString *productID = [self.carouselSource getProductIdByBundle:bundle];
    SKProduct *product = [self.carouselSource getProductById:productID];
    [[BundleIAPHelper sharedInstance] buyProduct:product];
}

- (void)productPurchased:(NSNotification *)notification {
    NSString * productIdentifier = notification.object;
    [self.carouselSource bundlePurchasedWithId:productIdentifier andGroup:self.group];
    [self.tableView reloadData];
}

#pragma mark Segment Cotrol Methods

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl{
    switch (segmentedControl.selectedSegmentIndex) {
        case BrokenGlass:
            self.group = BrokenGlass;
            break;
        case Scratches:{
            self.group = Scratches;
            break;
        }
        case Spray:
            self.group = Spray;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark In-Apps Restored 

- (void)productRestored:(NSNotification *)notification{
    NSString * productIdentifier = notification.object;
    [self.carouselSource bundlePurchasedWithId:productIdentifier andGroup:self.group];
    [self.tableView reloadData];
//    [self.carouselSource checkPurchasedBundles];
//    [self.tableView reloadData];
}

- (void)reloadAfterProductsArrived{
    [self.tableView reloadData];
}

@end
