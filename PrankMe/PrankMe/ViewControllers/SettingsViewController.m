//
//  SettingsViewController.m
//  PrankMe
//
//  Created by VIktor Sokolov on 08.09.14.
//  Copyright (c) 2014 ViktorSokolov. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>

#define kAppID @"ID"
#define kSupportEmail @"support@cratis-split.com"

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
                NSLog(@"Share this App");
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-apps://itunes.apple.com/app/" stringByAppendingString:kAppID]]];
                break;
            case 2:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cratis-split.com"]];
                break;
            default:
                break;
        }
    } else {
        [self showSupportEmail];
    }
}

- (void)showSupportEmail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[kSupportEmail]];
        [composeViewController setSubject:@"Prankstr support"];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result{
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
