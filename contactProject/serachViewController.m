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
#import "contactDetailViewController.h"
#import <ContactsUI/ContactsUI.h>
#import "AppDelegate.h"
@interface serachViewController ()<UISplitViewControllerDelegate,CNContactViewControllerDelegate,CNContactPickerDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>

@end
@implementation serachViewController
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [deleteContact addObject:displayContacts[indexPath.row]];
//}

-(IBAction)addNewItem:(id)sender{
    NSLog(@"before saveqqq");
    CNContact *OK = [[CNMutableContact alloc] init];
        [OK setValuesForKeysWithDictionary:@{
                                             CNContactFamilyNameKey: @"",
                                             CNContactNicknameKey: @""
                                             }
         
         ];
    CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:OK];
    controller.delegate=self;
    controller.contactStore = store;
//    controller.allowsActions= YES;
//    controller.allowsEditing = YES;
//    controller.shouldShowLinkedContacts = YES;
    NSLog(@"before save");

    [self.navigationController pushViewController:controller animated:YES];
  //  [self presentViewController:controller] animated:YES completion:  nil ];
    NSLog(@"saved contact");
    
   
}
-(void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact{
    if(contact == nil){
        [self.navigationController popViewControllerAnimated:YES];
    }else {
    
        [self loadContact];
        [table reloadData];
    }

}
-(void)saveContact:(NSString*)familyName givenName:(NSString*)givenName phoneNumber:(NSString*)phoneNumber {
    CNMutableContact *mutableContact = [[CNMutableContact alloc] init];
    
    mutableContact.givenName = givenName;
    mutableContact.familyName = familyName;
    NSString *full ;
    [self getfullname:givenName second:familyName];
    CNPhoneNumber * phone =[CNPhoneNumber phoneNumberWithStringValue:phoneNumber];
    
    mutableContact.phoneNumbers = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:phone], nil];
    CNContactStore *store = [[CNContactStore alloc] init];
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:mutableContact toContainerWithIdentifier:store.defaultContainerIdentifier];
    
    NSError *error;
    if([store executeSaveRequest:saveRequest error:&error]) {
        NSLog(@"aaaaaaa  save");
//        if ( full != nil ){
//            [self loadContact];
//        }
//
        NSLog(@"before");
        [table reloadData];
        NSLog(@"after");
    }else {
        NSLog(@"save error");
    }
}

-(NSString *)getfullname:(NSString *)firstName second:(NSString *)lastName{
    NSString *fullName;
    if (lastName == nil) {
        fullName=[NSString stringWithFormat:@"%@",firstName];
    }else if (firstName == nil){
        fullName=[NSString stringWithFormat:@"%@",lastName];
    }
    else{
        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    }
    return fullName;
    
}
-(void)loadContact{
    store = [[CNContactStore alloc] init];
    [displayContacts removeAllObjects];
    [displayItems removeAllObjects];
    [allItems removeAllObjects];
    [allContacts removeAllObjects];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
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
                    fullName = [self getfullname:firstName second:lastName];
                    [self->allItems addObject:contact];
                    [self->allContacts addObject:fullName];
                    
                }
                [self->displayItems addObjectsFromArray:self->allContacts];
                [self->displayContacts addObjectsFromArray:self->allItems];
                
                
            }
        }
    }];
    [table reloadData];
    NSLog(@"load");
    
    
    
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    allItems = [[NSMutableArray alloc] init ];
    allContacts = [[NSMutableArray alloc]init];
    displayContacts =[[NSMutableArray alloc]init];
    displayItems = [[NSMutableArray alloc]init];
    deleteContact = [[NSMutableArray alloc]init];
    [self loadContact];
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Contact List";
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    UIBarButtonItem *bbe = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItem:)];
    
    navItem.leftBarButtonItem = self.editButtonItem;
    navItem.rightBarButtonItem=bbi;
    NSLog(@"sadasd");
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    select = true ;
    [super setEditing:editing animated:YES];
   
   // [table setEditing:YES   animated:YES];
    if(editing){
         [deleteContact removeAllObjects];
        [table setEditing:YES animated:YES];
        
    }else {
        select = false ;
        NSLog(@"ytytytyytyt %d",[deleteContact count]);
        
        [self deleteItem];
        [table setEditing:NO animated:YES];
    }
}
-(void)deleteItem{
    NSLog(@"dlll");
//    NSMutableArray *temp = [[NSMutableArray alloc] init ];
//    [temp addObjectsFromArray:displayContacts];
//    [displayItems removeAllObjects];
//    [displayContacts removeAllObjects];
//
//    NSString *fullName;
//    NSString *firstName;
//    NSString *lastName;
//    for( CNContact *cc in temp){
//        firstName = cc.givenName;
//        lastName = cc.familyName;
//        fullName = [self getfullname:firstName second:lastName];
//
//        if(cc.identifier == contact.identifier){
//            NSLog(@"DELETED");
//            continue;
//        }else {
//            [displayItems addObject:fullName];
//            [displayContacts addObject:cc];
//        }
//    }
    for(CNContact *cc in deleteContact){
        [self deleteContact:cc];
    }
    [table reloadData];
    
}
//-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1 ;
//}
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
            fullName = [self getfullname:firstName second:lastName];
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
//    contactDetailViewController  *detail = [[contactDetailViewController alloc]init];
//    // NSArray *items=[[BNRItemStore sharedStore]allItems];
//    CNContact *selectedItem = displayContacts[indexPath.row];
//    detail.data = selectedItem ;
//    [self.navigationController pushViewController:detail animated:YES ];
    if(!select){
    CNContact *selectedItem = displayContacts[indexPath.row];
//    NSLog(@"selected item: %@", selectedItem);
//    CNContact *OK = [[CNMutableContact alloc] init];
//    [OK setValuesForKeysWithDictionary:@{
//                                         CNContactFamilyNameKey: @"ASD",
//                                         CNContactNicknameKey: @"QWE"
//                                         }
//     ];
//    controller = [[CNContactVi ewController alloc]init];
    CNContactViewController *controller = [CNContactViewController viewControllerForContact:selectedItem];
    controller.delegate=self;
    //controller.contactStore = store;
    controller.allowsActions= YES;
    controller.allowsEditing = YES;
    controller.shouldShowLinkedContacts = YES;
    [self.navigationController pushViewController:controller animated:YES ];
    }else{
        
        [deleteContact addObject:displayContacts[indexPath.row]];
        NSLog(@"delete signal");
        if([deleteContact count] > 0 ){
            self.editButtonItem.title = @"Delete";
        }else {
            self.editButtonItem.title = @"Done";
        }
       
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"delete signal");

  [deleteContact removeObject:displayContacts[indexPath.row]];
    if([deleteContact count] > 0 ){
        self.editButtonItem.title = @"Delete";
    }else {
        self.editButtonItem.title = @"Done";
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(editingStyle == UITableViewCellEditingStyleDelete){
//        CNContact *selectedItem = displayContacts[indexPath.row];
//        [self deleteContact:selectedItem];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//    }
//
//}
-(void)deleteContact:(CNContact*)contact {
  //  [allItems removeAllObjects];
   // [allContacts removeAllObjects];
    NSMutableArray *temp = [[NSMutableArray alloc] init ];
    [temp addObjectsFromArray:displayContacts];
    [displayItems removeAllObjects];
    [displayContacts removeAllObjects];
    
    NSString *fullName;
    NSString *firstName;
    NSString *lastName;
    NSString *OK ;
    for( CNContact *cc in temp){
        firstName = cc.givenName;
        lastName = cc.familyName;
        fullName = [self getfullname:firstName second:lastName];
        
        if(cc.identifier == contact.identifier){
            [allContacts removeObject:fullName];
            [allItems removeObject:cc];
            NSLog(@"DELETED");
            continue;
        }else {
            [displayItems addObject:fullName];
            [displayContacts addObject:cc];
       
        }
    }
    
  //  [allItems addObjectsFromArray:displayItems];
  //  [allContacts addObjectsFromArray:displayContacts];
    
  
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 3 ;
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
