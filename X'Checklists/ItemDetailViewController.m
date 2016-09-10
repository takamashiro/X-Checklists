//
//  ItemDetailViewController.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/10.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistViewController.h"
#import "ChecklistItem.h"

@interface ItemDetailViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, strong) ChecklistViewController *checklistViewController;
@end

@implementation ItemDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.itemToEdit) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel{
    if([self.delegate respondsToSelector:@selector(itemDetailViewControllerDidCancel:)]) {
        [self.delegate itemDetailViewControllerDidCancel:self];
    }
}

- (IBAction)done {
    
    
    if (self.itemToEdit) {
        ChecklistItem *item = self.itemToEdit;
        item.text = self.textField.text;
        if([self.delegate respondsToSelector:@selector(itemDetailViewController:didFinishEditingItem:)]) {
            [self.delegate itemDetailViewController:self didFinishEditingItem:item];
        }
    } else {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.textField.text;
        item.checked = false;
        if([self.delegate respondsToSelector:@selector(itemDetailViewController:didFinishAddingItem:)]) {
            [self.delegate itemDetailViewController:self didFinishAddingItem:item];
        }
    }
}

#pragma -mark table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma -mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *oldText = textField.text;
    NSString *newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    
    
        self.doneBarButton.enabled = newText.length > 0;
        return YES;
}


@end
