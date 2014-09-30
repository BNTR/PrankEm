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
#import <Social/Social.h>

@interface ShareViewController ()<MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIImage *completeImage;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;

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
    
    UIImageWriteToSavedPhotosAlbum(self.completeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary*)info{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Your image successfully saved to Album" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)instagramButtonTapped:(id)sender{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        CGFloat cropVal = (self.completeImageView.image.size.height > self.completeImageView.image.size.width ? self.completeImageView.image.size.width : self.completeImageView.image.size.height);
        
        cropVal *= [self.completeImageView.image scale];
        
        CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
        CGImageRef imageRef = CGImageCreateWithImageInRect([self.completeImageView.image CGImage], cropRect);
        
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
        CGImageRelease(imageRef);
        
        NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
        if (![imageData writeToFile:writePath atomically:YES]) {
            // failure
            NSLog(@"image save failed to path %@", writePath);
            return;
        } else {
            // success.
        }
        
        // send it to instagram.
        NSURL *fileURL = [NSURL fileURLWithPath:writePath];
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        self.documentController.delegate = self;
        [self.documentController setUTI:@"com.instagram.exclusivegram"];
        [self.documentController setAnnotation:@{@"InstagramCaption" : @"We are making fun"}];
        [self.documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 320, 480) inView:self.view animated:YES];
    }
    else
    {
        NSLog (@"Instagram not found");
    }
}

- (IBAction)facebookButtonTapped:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Facebook"];
        [controller addImage:self.completeImage];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
}

- (IBAction)twitterButtonTapped:(id)sender{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Twitter"];
        [tweetSheet addImage:self.completeImage];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)mailButtonTapped:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setSubject:@"Prank Them photo"];
        NSData *myData = UIImagePNGRepresentation(self.completeImage);
        [composeViewController addAttachmentData:myData mimeType:@"image/png" fileName:@"PrankThemPhoto.png"];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textButtonTapped:(id)sender{
    if ([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] initWithNibName:nil bundle:nil];
        picker.messageComposeDelegate = self;
        picker.body = @"Pranked photo!";
        NSData* data = UIImagePNGRepresentation(self.completeImage);
        [picker addAttachmentData:data typeIdentifier:@"image/png" filename:@"image.png"];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSString *messageResult;
    if (result == MessageComposeResultCancelled){
        messageResult = @"Message cancelled";
    } else if (result == MessageComposeResultSent) {
        messageResult = @"Message sent";
    } else {
        messageResult = @"Message failed";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:messageResult
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    [alert show];
}

- (void)goToGallery{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
