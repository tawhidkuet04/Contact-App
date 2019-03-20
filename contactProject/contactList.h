//
//  contactList.h
//  contactProject
//
//  Created by Tawhid Joarder on 3/20/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface contactList : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSString *fullName;
@property NSString *number;
-(instancetype)initWithFirstName:(NSString *)fname  lastName:(NSString *)lname fullName:(NSString *)full number:(NSString *)num;

@end

NS_ASSUME_NONNULL_END
