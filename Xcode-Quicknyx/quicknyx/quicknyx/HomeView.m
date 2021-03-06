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
    IBOutlet UITextView *txtNotes;
    IBOutlet UITextView *txtHardware;
    IBOutlet UIDatePicker *txtDate;
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy 'at' h:mm a"];
    NSString *dateString = [formatter stringFromDate:txtDate.date ];
    
    NSString *string=[NSString stringWithFormat:@"Date: %@\n\n Client: %@\n Time: %@ \n\n Notes: \n %@ \n\n Hardware: \n %@",dateString,txtClient.text,txtTime.text,txtNotes.text,txtHardware.text];
    dateString = @"";
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
