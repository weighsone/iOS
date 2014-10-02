//
//  SettingScreen.m
//  Quicknyx
//
//  Created by Jono on 7/24/14.
//  Copyright (c) 2014 Jono. All rights reserved.
//

#import "SettingScreen.h"

@interface SettingScreen ()
{
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtSubject;
}
@end

@implementation SettingScreen


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    txtEmail.text=[userDefault objectForKey:@"Email"];
    txtSubject.text=[userDefault objectForKey:@"Subject"];
}
-(BOOL)emailisValid:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}
-(IBAction)doneBtnTapped:(id)sender
{
    //
    //Error checking to see if values have been entered
    //
    //if ([txtEmail.text length]==0 ||[txtSubject.text length]==0)
    //{
    //    DisplayAlertWithTitle(@"All Field are require");
    //    return;
    //}
    //else if (![self emailisValid:txtEmail.text])
    //{
    //    DisplayAlertWithTitle(@"This Email is not Valid");
    //    return;
    //}
    
    
    [userDefault setObject:txtEmail.text forKey:@"Email"];
    [userDefault setObject:txtSubject.text forKey:@"Subject"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
