//
//  contactList.m
//  contactProject
//
//  Created by Tawhid Joarder on 3/20/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "contactList.h"

@implementation contactList
-(instancetype)initWithFirstName:(NSString *)fname lastName:(NSString *)lname fullName:(NSString *)full number:(NSString *)num{
    self = [super init];
    if(self){
        _firstName = fname;
        _lastName  = lname ;
        _fullName = full;
        _number = num ;
        
    }
    return self ;
    
}
@end
