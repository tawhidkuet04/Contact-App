//
//  serachViewController.h
//  contactProject
//
//  Created by Tawhid Joarder on 3/20/19.
//  Copyright © 2019 Tawhid Joarder. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface serachViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *table;
    NSMutableArray *allItems;
    NSMutableArray *displayItems;
}
@end

NS_ASSUME_NONNULL_END
