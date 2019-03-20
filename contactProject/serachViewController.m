//
//  serachViewController.m
//  contactProject
//
//  Created by Tawhid Joarder on 3/20/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import "serachViewController.h"
#import <Contacts/Contacts.h>
#import "deatailViewController.h"
@interface serachViewController ()

@end

@implementation serachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    store = [[CNContactStore alloc] init];
    allItems = [[NSMutableArray alloc] init ];
    allContacts = [[NSMutableArray alloc]init];
    displayContacts =[[NSMutableArray alloc]init];
    displayItems = [[NSMutableArray alloc]init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = self->store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [self->store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
          
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
    
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                  
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    
                    [self->allItems addObject:contact];
                    [self->allContacts addObject:fullName];
                    
                }
                [self->displayItems addObjectsFromArray:self->allContacts];
                [self->displayContacts addObjectsFromArray:self->allItems];
                
             
            }
        }
    }];
    
  
   
    
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [displayItems count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [ [UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" ];
    }
    cell.textLabel.text = [displayItems objectAtIndex:indexPath.row];
    return cell ;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText length] ==0){
        [displayItems removeAllObjects];
        [displayItems addObjectsFromArray:allContacts];
        [displayContacts removeAllObjects];
        [displayContacts addObjectsFromArray:allItems];
    }else {
        [displayItems removeAllObjects];
        [displayContacts removeAllObjects];
        NSString *fullName;
        NSString *firstName;
        NSString *lastName;
        for( CNContact *contact in allItems){
            firstName = contact.givenName;
            lastName = contact.familyName;
            
            if (lastName == nil) {
                fullName=[NSString stringWithFormat:@"%@",firstName];
            }else if (firstName == nil){
                fullName=[NSString stringWithFormat:@"%@",lastName];
            }
            else{
                fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
            }
            NSRange r = [fullName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound){
                [displayItems addObject:fullName];
                [displayContacts addObject:contact];
            }
        }
    }
    [table reloadData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    deatailViewController *detail = [[deatailViewController alloc]init];
    // NSArray *items=[[BNRItemStore sharedStore]allItems];
    CNContact *selectedItem = displayContacts[indexPath.row];
    detail.data = selectedItem ;
    [self.navigationController pushViewController:detail animated:YES ];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
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
