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

@property (nonatomic, strong) SLComposeViewController *facebookController;
@property (nonatomic, strong) SLComposeViewController *twitterController;
@property (nonatomic, strong) MFMailComposeViewController *mailViewController;
@property (nonatomic, strong) MFMessageComposeViewController *messagePicker;

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
    
    self.facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [self.facebookController setInitialText:@"Prankstr photo"];
    [self.facebookController addImage:self.completeImage];
    
    self.twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self.twitterController setInitialText:@"Prankstr photo"];
    [self.twitterController addImage:self.completeImage];
    
    NSData *data = UIImagePNGRepresentation(self.completeImage);
    self.mailViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
    [self.mailViewController setMailComposeDelegate:self];
    [self.mailViewController setSubject:@"Prankstr photo"];
    [self.mailViewController addAttachmentData:data mimeType:@"image/png" fileName:@"PrankstrPhoto.png"];
    
    self.messagePicker = [[MFMessageComposeViewController alloc] initWithNibName:nil bundle:nil];
    self.messagePicker.messageComposeDelegate = self;
    self.messagePicker.body = @"Prankstr photo";
    [self.messagePicker addAttachmentData:data typeIdentifier:@"image/png" filename:@"PrankstrPhoto.png"];

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
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        [self presentViewController:self.facebookController animated:YES completion:Nil];
    }
}

- (IBAction)twitterButtonTapped:(id)sender{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        [self presentViewController:self.twitterController animated:YES completion:nil];
    }
}

- (IBAction)mailButtonTapped:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        [self presentViewController:self.mailViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textButtonTapped:(id)sender{
    if ([MFMessageComposeViewController canSendText]){
        [self presentViewController:self.messagePicker animated:YES completion:nil];
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
