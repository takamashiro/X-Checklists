//
//  ListDetailViewController.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/11.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListDetailViewController;
@class Checklist;

@protocol ListDetailViewControllerDelegate <NSObject>


- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist;

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;

@end

@interface ListDetailViewController : UITableViewController

@property (weak,nonatomic) IBOutlet UITextField *textField;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@property (nonatomic, strong) Checklist *checklistToEdit;
@property (nonatomic, weak) id<ListDetailViewControllerDelegate> delegate;
@end
