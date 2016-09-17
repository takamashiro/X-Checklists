//
//  ListDetailViewController.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/11.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "ListDetailViewController.h"
#import "Checklist.h"
#import "IconPickerViewController.h"
@interface ListDetailViewController ()<UITextFieldDelegate,IconPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic,copy) NSString *iconName;
@end

@implementation ListDetailViewController

- (NSString *)iconName {
    if (_iconName==nil ||!_iconName) {
        _iconName = @"Folder";
    }
    return _iconName;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 44;
    if (self.checklistToEdit) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checklistToEdit.name;
        self.doneBarButton.enabled = YES;
        
        self.iconName = self.checklistToEdit.iconName;
    }
    self.iconImageView.image = [UIImage imageNamed:self.iconName];
}

- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName {
    self.iconName = iconName;
    self.iconImageView.image= [UIImage imageNamed:iconName];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel{
    if([self.delegate respondsToSelector:@selector(listDetailViewControllerDidCancel:)]) {
        [self.delegate listDetailViewControllerDidCancel:self];
    }
}

- (IBAction)done
{
    Checklist *checklist = self.checklistToEdit;
    if (checklist == nil) {
        checklist = [[Checklist alloc] initWithName:self.textField.text];
        checklist.iconName = self.iconName;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    } else {
        self.checklistToEdit.name = self.textField.text;
        checklist.iconName = self.iconName;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1) {
        return indexPath;
    } else {
    return nil;
    }
}

#pragma -mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *oldText = textField.text;
    NSString *newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    
    
    self.doneBarButton.enabled = newText.length > 0;
    return YES;
}

@end
