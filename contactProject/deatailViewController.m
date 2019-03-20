//
//  deatailViewController.m
//  contactProject
//
//  Created by Tawhid Joarder on 3/20/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "deatailViewController.h"
#import <Contacts/Contacts.h>
@interface deatailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fName;
@property (weak, nonatomic) IBOutlet UILabel *lName;
@property (weak, nonatomic) IBOutlet UILabel *mNumber;
@property (weak, nonatomic) IBOutlet UILabel *emailAddress;
@property (weak, nonatomic) IBOutlet UILabel *birthDate;


@end

@implementation deatailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
