//
//  ShopViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopItemCell.h"
#import "AnimationSegment.h"

static float duration = 0.4;

@interface ShopViewController ()<UITableViewDataSource, UITableViewDelegate>{

BOOL isFirst;
BOOL isSecond;


BOOL   isNormalFirst;
BOOL   isNormalSecond;
BOOL   isNormalThird;
BOOL   isNormalFourth;
}

@property (nonatomic, strong) NSString *cellValue;

@property (strong, nonatomic) IBOutlet UIView *segmentControlView;
@property (strong, nonatomic) AnimationSegment * changeSegment;

- (IBAction)actionFirstSegment:(id)sender;
- (IBAction)actionSecoundSegment:(id)sender;
- (IBAction)actionThirdSegment:(id)sender;
- (IBAction)actionFourthSegment:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *firstSegmentControlItem;
@property (strong, nonatomic) IBOutlet UIButton *secondSegmentControlItem;
@property (strong, nonatomic) IBOutlet UIButton *thirdSegmentControlItem;
@property (strong, nonatomic) IBOutlet UIButton *fourthSegmentControlItem;

@end

@implementation ShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cellValue = @"Broken Glass";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.changeSegment = [[AnimationSegment alloc] init];
    self.changeSegment.Duration = duration;
    isNormalFirst = NO;
    isNormalSecond = YES;
    isNormalThird = YES;
    isNormalFourth = YES;
    
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
    
    [self setupSegmentControl];
}

- (void)setupSegmentControl{
    self.firstSegmentControlItem.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10.0];
    self.secondSegmentControlItem.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10.0];
    self.thirdSegmentControlItem.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10.0];
    self.fourthSegmentControlItem.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10.0];
    
    self.segmentControlView.layer.borderColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0].CGColor;
    self.segmentControlView.layer.borderWidth = 1;
    self.segmentControlView.layer.cornerRadius = 5;
    
    self.firstSegmentControlItem.layer.borderWidth = 1;
    self.firstSegmentControlItem.layer.cornerRadius = 5;
    self.firstSegmentControlItem.layer.borderColor = [UIColor clearColor].CGColor;
    self.firstSegmentControlItem.layer.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0].CGColor;
    self.firstSegmentControlItem.titleLabel.textColor = [UIColor whiteColor];
    
    
    
    self.fourthSegmentControlItem.layer.borderWidth = 1;
    self.fourthSegmentControlItem.layer.cornerRadius = 5;
    self.fourthSegmentControlItem.layer.borderColor = [UIColor clearColor].CGColor;
    self.fourthSegmentControlItem.titleLabel.textColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    self.secondSegmentControlItem.layer.borderWidth = 1;
    self.secondSegmentControlItem.layer.borderColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0].CGColor;
    self.secondSegmentControlItem.titleLabel.textColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    self.thirdSegmentControlItem.layer.borderWidth = 1;
    self.thirdSegmentControlItem.layer.borderColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0].CGColor;
    self.thirdSegmentControlItem.titleLabel.textColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
}

- (IBAction)actionFirstSegment:(id)sender {
    [self actionFirstSegment];
}

- (IBAction)actionSecoundSegment:(id)sender {
    [self actionSecondSegment];
}

- (IBAction)actionThirdSegment:(id)sender {
    [self actionThirdSegment];
}

- (IBAction)actionFourthSegment:(id)sender{
    [self actionFourthSegment];
}

- (void)actionFirstSegment {
    
    if (!isNormalFirst) {
        
        NSLog(@"Allready pressd");
    } else if (isNormalFirst) {
        [self changeFirstPressed];
        [self changeSecondNormal];
        [self changeThirdNormal];
        [self changeFourthNormal];
        isNormalFirst = NO;
        isNormalSecond = YES;
        isNormalThird = YES;
        isNormalFourth = YES;
        [self segmentedControlValueChanged:0];
        NSLog(@"Your action");

    }
}

- (void) actionSecondSegment {
    
    if (!isNormalSecond) {
        
        NSLog(@"Allready pressd");
        
    } else if (isNormalSecond) {
        [self changeFirstNormal];
        [self changeSecondPressed];
        [self changeThirdNormal];
        [self changeFourthNormal];
        isNormalFirst = YES;
        isNormalSecond = NO;
        isNormalThird = YES;
        isNormalFourth = YES;
        [self segmentedControlValueChanged:1];
        NSLog(@"Your action");
    }
}

- (void) actionThirdSegment {
    if (!isNormalThird) {
        
        NSLog(@"Allready pressd");
        
    } else if (isNormalThird){
        [self changeFirstNormal];
        [self changeSecondNormal];
        [self changeThirdPressed];
        [self changeFourthNormal];
        isNormalFirst = YES;
        isNormalSecond = YES;
        isNormalThird = NO;
        isNormalFourth = YES;
        [self segmentedControlValueChanged:2];
        NSLog(@"Your action");
    }
}

- (void) actionFourthSegment {
    if (!isNormalFourth) {
        
        NSLog(@"Allready pressd");
        
    } else if (isNormalFourth){
        [self changeFirstNormal];
        [self changeSecondNormal];
        [self changeThirdNormal];
        [self changeFourthPressed];
        isNormalFirst = YES;
        isNormalSecond = YES;
        isNormalThird = YES;
        isNormalFourth = NO;
        [self segmentedControlValueChanged:3];
        NSLog(@"Your action");
    }
}

- (void) changeFirstPressed {
    
    self.changeSegment.segmentButton = self.firstSegmentControlItem;
    self.changeSegment.segmentButtonTextColor = [UIColor whiteColor];
    self.changeSegment.segmentButtonBGColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    [self.changeSegment changeSegment];
}

- (void) changeSecondPressed {
    self.changeSegment.segmentButton = self.secondSegmentControlItem;
    self.changeSegment.segmentButtonTextColor = [UIColor whiteColor];
    self.changeSegment.segmentButtonBGColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    [self.changeSegment changeSegment];
}

- (void) changeThirdPressed {
    self.changeSegment.segmentButton = self.thirdSegmentControlItem;
    self.changeSegment.segmentButtonTextColor = [UIColor whiteColor];
    self.changeSegment.segmentButtonBGColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    [self.changeSegment changeSegment];
}

- (void) changeFourthPressed {
    self.changeSegment.segmentButton = self.fourthSegmentControlItem;
    self.changeSegment.segmentButtonTextColor = [UIColor whiteColor];
    self.changeSegment.segmentButtonBGColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    [self.changeSegment changeSegment];
}

- (void) changeFirstNormal {
    self.changeSegment.segmentButton = self.firstSegmentControlItem;
    self.changeSegment.segmentButtonTextColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.changeSegment.segmentButtonBGColor = [UIColor whiteColor];
    [self.changeSegment changeSegment];
}

- (void) changeSecondNormal {
    self.changeSegment.segmentButton = self.secondSegmentControlItem;
    self.changeSegment.segmentButtonTextColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.changeSegment.segmentButtonBGColor = [UIColor whiteColor];
    [self.changeSegment changeSegment];
}

- (void) changeThirdNormal {
    self.changeSegment.segmentButton = self.thirdSegmentControlItem;
    self.changeSegment.segmentButtonTextColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.changeSegment.segmentButtonBGColor = [UIColor whiteColor];
    [self.changeSegment changeSegment];
}

- (void) changeFourthNormal {
    self.changeSegment.segmentButton = self.fourthSegmentControlItem;
    self.changeSegment.segmentButtonTextColor = [UIColor colorWithRed:1.0/255.0 green:139.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.changeSegment.segmentButtonBGColor = [UIColor whiteColor];
    [self.changeSegment changeSegment];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ShopCell";
    ShopItemCell *cell = (ShopItemCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.itemImage.image = [UIImage imageNamed:@"sampleFilterImage"];
    cell.itemTopLabel.text = [NSString stringWithFormat:@"%@ 1", self.cellValue];
    cell.itemBottomLabel.text = @"6 effects";
    cell.itemPriceLabel.text = @"1,99 $";
    cell.itemPriceLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14.035];
    [cell.itemButton addTarget:self action:@selector(buyFilters) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor clearColor];
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 320, 81.0)];
    UIView *backgroundLine = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 320, 81.0)];
    backgroundLine.backgroundColor = [UIColor whiteColor];
    backgroundLine.alpha = 0.2;
    [background addSubview:backgroundLine];
    cell.backgroundView = background;

    return cell;
}

- (void)buyFilters{
    NSLog(@"buyFilters");
}

#pragma mark Segment Cotrol Methods

- (void)segmentedControlValueChanged:(NSInteger)index{
    switch (index) {
        case 0:
            self.cellValue = @"Broken Glass";
            break;
        case 1:
            self.cellValue = @"Scratches";
            break;
        case 2:
            self.cellValue = @"Dents";
            break;
        case 3:
            self.cellValue = @"Sprey";
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

@end
