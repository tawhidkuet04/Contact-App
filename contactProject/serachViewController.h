//
//  serachViewController.h
//  contactProject
//
//  Created by Tawhid Joarder on 3/20/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
NS_ASSUME_NONNULL_BEGIN

@interface serachViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    IBOutlet UITableView *table;
    IBOutlet UISearchBar *searchBar;
    NSMutableArray *allItems;
    NSMutableArray *displayContacts;
    NSMutableArray *displayItems;
    NSMutableArray *allContacts;
    CNContactStore *store;
}
-(NSString *)getfullname:(NSString *)firstName second:(NSString *)lastName;
@end

NS_ASSUME_NONNULL_END
