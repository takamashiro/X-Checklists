//
//  ViewController.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/9.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
#import "Checklist.h"

@interface ChecklistViewController : BaseTableViewController<ItemDetailViewControllerDelegate>

@property (nonatomic, strong) Checklist *checklist;
@end

