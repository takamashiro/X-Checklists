//
//  ListDetailViewController.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/11.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "ListDetailViewController.h"
#import "Checklist.h"
@interface ListDetailViewController ()<UITextFieldDelegate>

@end

@implementation ListDetailViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.checklistToEdit) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checklistToEdit.name;
        self.doneBarButton.enabled = YES;
    }

}


- (IBAction)cancel{
    if([self.delegate respondsToSelector:@selector(listDetailViewControllerDidCancel:)]) {
        [self.delegate listDetailViewControllerDidCancel:self];
    }
}

- (IBAction)done
{
    if (self.checklistToEdit == nil) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
        
    } else {
        self.checklistToEdit.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



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
