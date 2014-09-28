//
//  HomeView.m
//  Quicknyx
//
//  Created by Jono on 7/24/14.
//  Copyright (c) 2014 Jono. All rights reserved.
//

#import "HomeView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "SettingScreen.h"

@interface HomeView ()<MFMailComposeViewControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *txtClient;
    IBOutlet UITextField *txtTime;
    //IBOutlet UITextField *txtNotes;
    IBOutlet UITextView *txtNotes;
    IBOutlet UITextView *txtHardware;
}
@end

@implementation HomeView
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(IBAction)SettingBtnTapped:(id)sender
{
    SettingScreen *setting=[[SettingScreen alloc] initWithNibName:@"SettingScreen" bundle:nil];
    
    [self.navigationController pushViewController:setting animated:YES];
}

-(IBAction)doneBtnTapped:(id)sender
{
    //
    //Check that content has been put in the fields
    //
    if ([txtClient.text length]==0)
    {
        DisplayAlertWithTitle(@"Please enter client name");
        return;
    }
    else if ([txtTime.text length]==0)
    {
        DisplayAlertWithTitle(@"Please enter time");
        return;
    }
    else if ([txtNotes.text length]==0)
    {
        DisplayAlertWithTitle(@"Please enter some brief notes");
        return;
    }
    else if ([[userDefault objectForKey:@"Subject"] length]==0 ||[[userDefault objectForKey:@"Email"] length]==0)
    {
        DisplayAlertWithTitle(@"Please set Email address and subject before submitting");
        return;
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:[userDefault objectForKey:@"Subject"]];
    
    [picker setToRecipients:[NSArray arrayWithObject:[userDefault objectForKey:@"Email"]]];
    
    
    NSString *string=[NSString stringWithFormat:@"Client: %@\n Time: %@ \n\n Notes: \n %@ \n Hardware: \n %@",txtClient.text,txtTime.text,txtNotes.text,txtHardware.text];
    txtClient.text = @"";
    txtTime.text = @"";
    txtNotes.text = @"";
    txtHardware.text = @"";
    [picker setMessageBody:string isHTML:NO];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    UITouch *touch = [[event allTouches] anyObject];
//    if ([_UItextField isFirstResponder] && [touch view] != _UItextField) {
//        [_UItextField resignFirstResponder];
//    }
//    [super touchesBegan:touches withEvent:event];
//}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
