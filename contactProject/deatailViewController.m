//
//  deatailViewController.m
//  contactProject
//
//  Created by Tawhid Joarder on 3/20/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "deatailViewController.h"
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface deatailViewController () <MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fName;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (weak, nonatomic) IBOutlet UILabel *mNumber;
@property (weak, nonatomic) IBOutlet UILabel *emailAddress;
@property (weak, nonatomic) IBOutlet UILabel *birthDate;



@end

@implementation deatailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     UITapGestureRecognizer* mail1LblGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mail1LblTapped:)];
    [_emailAddress setText:@""];
    [_emailAddress setUserInteractionEnabled:YES];
    [_emailAddress  addGestureRecognizer:mail1LblGesture];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@" viewDidLoad at Detail View ");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.fName.text = _data.givenName;
    self.lName.text = _data.familyName;
    NSString *phone;
    for (CNLabeledValue *label in _data.phoneNumbers) {
        phone = [label.value stringValue];
        if ([phone length] > 0) {
            break;
        }
    }
    CNLabeledValue *emailValue = _data.emailAddresses.firstObject;
    NSString *emailLable = emailValue.value;
    self.emailAddress.text = emailLable;
    self.mNumber.text = phone ;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDate* date = [calendar dateFromComponents:_data.birthday];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MMMM dd, yyyy";
    NSString* dateString = [formatter stringFromDate:date];
    self.birthDate.text = dateString;
    _EM = emailLable;
}
- (void)mail1LblTapped:(id)sender
{
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    NSString *em = _EM;
    NSArray *toRecipents = [NSArray arrayWithObject:em];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
