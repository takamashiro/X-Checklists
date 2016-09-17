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
@property (weak, nonatomic) IBOutlet UISwitch *shouldRemindSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (nonatomic, strong) ChecklistViewController *checklistViewController;

@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, assign) BOOL datePickerVisible;

@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation ItemDetailViewController
- (IBAction)dateChanged {
    self.dueDate = self.datePicker.date;
    [self updateDueDateLabel];
}
- (IBAction)shouldRemindToggled:(UISwitch *)sender {
    
    [self.textField resignFirstResponder];
    if (sender.on) {
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
}


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
        
        self.shouldRemindSwitch.on = self.itemToEdit.shouldRemind;
        self.dueDate = self.itemToEdit.dueDate;
    }
    [self updateDueDateLabel];
}

- (void)updateDueDateLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.dueDateLabel.text = [formatter stringFromDate:self.dueDate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDatePicker {
    self.datePickerVisible = YES;
   
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    
    UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePick = (UIDatePicker *)[datePickerCell viewWithTag:100];
    [datePick setDate:self.dueDate animated:NO];
}

- (void)hideDatePicker
{
    if (self.datePickerVisible) {
        self.datePickerVisible = NO;
        
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
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
        
        item.shouldRemind = self.shouldRemindSwitch.on;
        item.dueDate = self.dueDate;
        [item scheduleNotification];
        if([self.delegate respondsToSelector:@selector(itemDetailViewController:didFinishEditingItem:)]) {
            [self.delegate itemDetailViewController:self didFinishEditingItem:item];
        }
    } else {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.textField.text;
        item.checked = false;
        
        item.shouldRemind = self.shouldRemindSwitch.on;
        item.dueDate = self.dueDate;
        [item scheduleNotification];
        if([self.delegate respondsToSelector:@selector(itemDetailViewController:didFinishAddingItem:)]) {
            [self.delegate itemDetailViewController:self didFinishAddingItem:item];
        }
    }
}

#pragma -mark table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 && _datePickerVisible) {
        return 3;
    } else {
         return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 &&indexPath.row == 2) {
        return 217;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && indexPath.section == 1) {
        return indexPath;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.textField resignFirstResponder];
    
    if (indexPath.row == 1 && indexPath.section == 1) {
        if (!_datePickerVisible) {
            [self showDatePicker];
        } else {
            [self hideDatePicker];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 &&indexPath.row == 2) {
        return self.datePickerCell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}
#pragma -mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *oldText = textField.text;
    NSString *newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    
    
        self.doneBarButton.enabled = newText.length > 0;
        return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hideDatePicker];
}

@end
