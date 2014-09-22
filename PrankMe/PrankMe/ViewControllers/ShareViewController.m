//
//  ShareViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 16.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "ShareViewController.h"
#import "GalleryViewController.h"
#import <MessageUI/MessageUI.h>

@interface ShareViewController ()<MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIImage *completeImage;

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCompleteImage:(UIImage *)completeImage{
    self = [super initWithNibName:@"ShareViewController" bundle:nil];
    if (self) {
        self.completeImage = completeImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.completeImageView.image = self.completeImage;
    self.navigationItem.title = @"Share";
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *doneButtonImage = [UIImage imageNamed:@"doneButton"];
    doneButton.frame = CGRectMake(0, 0, doneButtonImage.size.width, doneButtonImage.size.height);
    [doneButton setBackgroundImage:doneButtonImage forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(goToGallery) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)instagramButtonTapped:(id)sender{
    NSLog(@"instagramButtonTapped");
}

- (IBAction)facebookButtonTapped:(id)sender{
    NSLog(@"facebookButtonTapped");
}

- (IBAction)twitterButtonTapped:(id)sender{
    NSLog(@"twitterButtonTapped");
}

- (IBAction)mailButtonTapped:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setSubject:@"PrankEm photo"];
        NSData *myData = UIImageJPEGRepresentation(self.completeImage, 0.9);
        [composeViewController addAttachmentData:myData mimeType:@"image/jpg" fileName:@"PrankEmPhoto.jpg"];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    NSLog(@"mailButtonTapped");
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textButtonTapped:(id)sender{
    NSLog(@"textButtonTapped");
}

- (void)goToGallery{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
