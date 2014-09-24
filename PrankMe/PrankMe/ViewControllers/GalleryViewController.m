//
//  GalleryViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "GalleryViewController.h"
#import "SettingsViewController.h"
#import "ShopViewController.h"
#import "GalleryCell.h"
#import "ImageEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GalleryViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) SettingsViewController *settingsVC;
@property (nonatomic, strong) ShopViewController *shopVC;
@property (nonatomic, strong) ImageEditViewController *imageEditVC;

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imagesFromRoll = [[NSArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3.0/255.0 green:101.0/255.0 blue:169.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsButtonImage = [UIImage imageNamed:@"settingsButton"];
    settingsButton.frame = CGRectMake(0, 0, settingsButtonImage.size.width, settingsButtonImage.size.height);
    [settingsButton setBackgroundImage:settingsButtonImage forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(goToSettingsScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shopButtonImage = [UIImage imageNamed:@"shopButton"];
    shopButton.frame = CGRectMake(0, 0, shopButtonImage.size.width, shopButtonImage.size.height);
    [shopButton setBackgroundImage:shopButtonImage forState:UIControlStateNormal];
    [shopButton addTarget:self action:@selector(goToShopScreen) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shopButton];
    self.navigationItem.title = @"PrankEm";

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.pictures.backgroundColor = [UIColor clearColor];
    [self getAllPictures];
    [self.pictures registerNib:[UINib nibWithNibName:@"GalleryCell" bundle:nil] forCellWithReuseIdentifier:@"GalleryCell"];

}

#pragma Navigation Buttons Action

- (void)goToSettingsScreen
{
    self.settingsVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:self.settingsVC animated:YES];
}

- (void)goToShopScreen
{
    self.shopVC = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    [self.navigationController pushViewController:self.shopVC animated:YES];
}

#pragma mark Buttons Action

- (IBAction)rollButtonTapped:(id)sender
{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

- (IBAction)cameraButtonTapped:(id)sender
{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

#pragma mark Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [photoPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageEditVC = [[ImageEditViewController alloc] initWithSelectedImage:selectedImage];
    [self.navigationController pushViewController:self.imageEditVC animated:YES];
}

#pragma mark Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesFromRoll.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(75, 75);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 28.0;
}
- (GalleryCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCell *cell = (GalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    ALAsset *asset = self.imagesFromRoll[indexPath.row];
    cell.asset = asset;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.imagesFromRoll[indexPath.row];
    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    UIImage *selectedImage = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MyImage.png"];
    
    // Convert UIImage object into NSData (a wrapper for a stream of bytes) formatted according to PNG spec
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    [imageData writeToFile:filePath atomically:YES];

    self.imageEditVC = [[ImageEditViewController alloc] initWithSelectedImage:selectedImage];
    [self.navigationController pushViewController:self.imageEditVC animated:YES];
}

#pragma mark - Assets Library Methods

- (void)getAllPictures
{
    self.imagesFromRoll= [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    ALAssetsLibrary *assetsLibrary = [GalleryViewController defaultAssetsLibrary];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                [tmpAssets addObject:result];
            }
        }];
        self.imagesFromRoll = tmpAssets;
        [self.pictures reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
