//
//  AllListsViewController.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/11.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChecklistViewController.h"
#import "ListDetailViewController.h"
#import "DataModel.h"
@interface AllListsViewController : UITableViewController<ListDetailViewControllerDelegate>
@property (nonatomic, strong) DataModel *dataModel;
@end
