//
//  ShopViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopItemCell.h"

@interface ShopViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *cellValue;

@end

@implementation ShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cellValue = @"Broken Glass";
        self.segmentControl.selectedSegmentIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Supply Shop";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStylePlain target:self action:@selector(restoreButtonTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped)];
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
    cell.itemImage.image = [UIImage imageNamed:@"image"];
    cell.itemTopLabel.text = [NSString stringWithFormat:@"%@ 1", self.cellValue];
    cell.itemBottomLabel.text = @"6 effects";
    return cell;
}

#pragma mark Segment Cotrol Methods

- (IBAction)segmentControlTapped:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
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
