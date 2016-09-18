//
//  ItemDetailViewController.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/10.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChecklistItem;
@class ItemDetailViewController;

@protocol ItemDetailViewControllerDelegate <NSObject>


- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller;

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item;

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item;

@end

@interface ItemDetailViewController : BaseTableViewController

@property (nonatomic, strong) ChecklistItem *itemToEdit;
@property (nonatomic, weak) id<ItemDetailViewControllerDelegate> delegate;
@end


