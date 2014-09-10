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
    
    [self getAllPictures];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(goToSettingsScreen)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Shop" style:UIBarButtonItemStylePlain target:self action:@selector(goToShopScreen)];
    self.navigationItem.title = @"PrankMe";
    
    [self.pictures registerNib:[UINib nibWithNibName:@"GalleryCell" bundle:nil] forCellWithReuseIdentifier:@"GalleryCell"];

}

#pragma Navigation Buttons Action

- (void)goToSettingsScreen{
    SettingsViewController *settingsVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)goToShopScreen{
    ShopViewController *shopVC = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    [self.navigationController pushViewController:shopVC animated:YES];
}

#pragma mark Buttons Action

- (IBAction)rollButtonTapped:(id)sender{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

- (IBAction)cameraButtonTapped:(id)sender{
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
    ImageEditViewController *imageEditVC = [[ImageEditViewController alloc] initWithSelectedImage:selectedImage];
    [self.navigationController pushViewController:imageEditVC animated:YES];
}

#pragma mark Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesFromRoll.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}

- (GalleryCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCell *cell = (GalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    ALAsset *asset = self.imagesFromRoll[indexPath.row];
    cell.asset = asset;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = self.imagesFromRoll[indexPath.row];
    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    UIImage *selectedImage = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
    ImageEditViewController *imageEditVC = [[ImageEditViewController alloc] initWithSelectedImage:selectedImage];
    [self.navigationController pushViewController:imageEditVC animated:YES];
}

#pragma mark - Assets Library Methods

- (void)getAllPictures
{
    self.imagesFromRoll= [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    // 1
    ALAssetsLibrary *assetsLibrary = [GalleryViewController defaultAssetsLibrary];
    // 2
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                // 3
                [tmpAssets addObject:result];
            }
        }];
        
        // 4
        //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        //self.assets = [tmpAssets sortedArrayUsingDescriptors:@[sort]];
        self.imagesFromRoll = tmpAssets;
        
        // 5
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
