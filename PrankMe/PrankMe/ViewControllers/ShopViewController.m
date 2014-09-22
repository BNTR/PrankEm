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

@interface ShopViewController ()<UITableViewDataSource, UITableViewDelegate>
    
@property (nonatomic, strong) CarouselSourceSingleton *carouselSource;

@property (nonatomic, strong) NSString *cellValue;
@property (nonatomic) Group group;

@property (strong, nonatomic) IBOutlet UIView *segmentControlView;

@end

@implementation ShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cellValue = @"Broken Glass";
        self.carouselSource = [CarouselSourceSingleton sharedCarouselSourceSingleton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    NSLog(@"Restore InApps");
}

- (void)doneButtonTapped{
    [self.imageEdit reloadCarousel];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
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
            //bundle = self.carouselSource.allBrokenGlassBundles[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    cell.itemImage.image = [UIImage imageNamed:@"sampleFilterImage"];
    cell.itemTopLabel.text = [NSString stringWithFormat:@"%@ %i", self.cellValue, (int)indexPath.row];
    NSArray *effects = bundle[0];
    NSDictionary *price = bundle[1];
    cell.itemBottomLabel.text = [NSString stringWithFormat:@"%i effects", (int)effects.count];
    cell.itemPriceLabel.text = price[@"price"];
    cell.itemPriceLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14.035];
    [cell.itemButton setTag:indexPath.row];
    [cell.itemButton addTarget:self action:@selector(buyFilters:) forControlEvents:UIControlEventTouchUpInside];
    
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
    NSInteger tag = sender.tag;
    NSMutableArray *bundle = [NSMutableArray array];
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            bundle = self.carouselSource.allBrokenGlassBundles[tag];
            break;
        }
        case 1:{
            bundle = self.carouselSource.allScratchesBundles[tag];
            break;
        }
        case 2:{
            //bundle = self.carouselSource.allBrokenGlassBundles[indexPath.row];
            break;
        }
        default:
            break;
    }

    BundleDetailViewController *bundleVC = [[BundleDetailViewController alloc] initWithBundle:bundle andBundleName:[NSString stringWithFormat:@"%@ %i", self.cellValue, (int)tag] andGroup:self.group];
    [self.navigationController pushViewController:bundleVC animated:YES];
}

#pragma mark Segment Cotrol Methods

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            self.cellValue = @"Broken Glass";
            self.group = BrokenGlass;
            break;
        case 1:{
            self.cellValue = @"Scratches";
            self.group = Scratches;
            break;
        }
        case 2:
            self.cellValue = @"Sprey";
            self.group = Sprey;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

@end
