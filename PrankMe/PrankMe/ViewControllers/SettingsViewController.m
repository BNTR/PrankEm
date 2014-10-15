//
//  SettingsViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>

#define kAppID @"926098427"
#define kSupportEmail @"support@cratisproduction.com"
#define kShareText @"You want to prank your friend? I use an app called Prankstr. It's a cool app that makes your friend's car seem scratched, sprayed on or their glass cracked. \n Check it out here:http://itunes.apple.com/app/926098427. \n Or check out our website cratissoftware.com."

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.navigationItem.title = @"Settings";
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *doneButtonImage = [UIImage imageNamed:@"doneButton"];
    doneButton.frame = CGRectMake(0, 0, doneButtonImage.size.width, doneButtonImage.size.height);
    [doneButton setBackgroundImage:doneButtonImage forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma Navigation Buttons Action

- (void)doneButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                [self showShareEmail];
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-apps://itunes.apple.com/app/" stringByAppendingString:kAppID]]];
                break;
            case 2:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cratissoftware.com"]];
                break;
            default:
                break;
        }
    } else {
        [self showSupportEmail];
    }
}

- (void)showShareEmail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *shareComposeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        shareComposeViewController.mailComposeDelegate = self;
        [shareComposeViewController setMailComposeDelegate:self];
        [shareComposeViewController setSubject:@"Have you tried this app?"];
        [shareComposeViewController setMessageBody:kShareText isHTML:NO];
        [self presentViewController:shareComposeViewController animated:YES completion:nil];
   }
}

- (void)showSupportEmail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *supportComposeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [supportComposeViewController setMailComposeDelegate:self];
        [supportComposeViewController setToRecipients:@[kSupportEmail]];
        [supportComposeViewController setSubject:@"Prankstr support"];
        supportComposeViewController.mailComposeDelegate = self;
        [self presentViewController:supportComposeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    UIAlertView *alert;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            alert = [[UIAlertView alloc] initWithTitle:@"Draft Saved" message:@"Mail is saved in draft." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultSent:
            alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully send email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case MFMailComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Sorry! Failed to send." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Table View Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 3;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"App Store";
    } else {
        return @"About";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32.5)];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellTableSection"]];
    [header addSubview:headerImage];
    NSString *title;
    if (section == 0){
        title = @"App Store";
    } else {
        title = @"About";
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320, 32.5)];
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [header addSubview:titleLabel];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsCellArrow"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Share this App";
                break;
            case 1:
                cell.textLabel.text = @"Rate us in the App Store!";
                break;
            case 2:
                cell.textLabel.text = @"Checkout our website";
                break;
                
            default:
                break;
        }
    } else {
        cell.textLabel.text = @"Help/Support";
    }
    cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18.0];
    
    cell.backgroundColor = [UIColor clearColor];
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 320, 32.5)];
    UIView *backgroundLine = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 320, 32.5)];
    backgroundLine.backgroundColor = [UIColor whiteColor];
    backgroundLine.alpha = 0.2;
    [background addSubview:backgroundLine];
    cell.backgroundView = background;
    return cell;
}

@end
