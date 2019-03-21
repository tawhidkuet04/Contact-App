//
//  contactDetailViewController.h
//  contactProject
//
//  Created by Tawhid Joarder on 3/21/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
NS_ASSUME_NONNULL_BEGIN

@interface contactDetailViewController : UIViewController
@property(nonatomic) CNContact *data;
@end

NS_ASSUME_NONNULL_END
