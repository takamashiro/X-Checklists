//
//  AllListsViewController.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/11.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "AllListsViewController.h"
#import "Checklist.h"
@interface AllListsViewController ()

@end

@implementation AllListsViewController



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowChecklist"]) {
        ChecklistViewController *controller = segue.destinationViewController;
        controller.checklist = sender;
    } else if([segue.identifier isEqualToString:@"AddChecklist"]) {
        UINavigationController *navigation = segue.destinationViewController;
        ListDetailViewController *controller = (ListDetailViewController *)navigation.topViewController;
        controller.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            controller.checklistToEdit = nil;
        }

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataModel.lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForTableView:tableView];
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    cell.textLabel.text = checklist.name;
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    
    
    return cell;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell) {
        return cell;
    } else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailNavigationController"];
    
    
    ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
    
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    controller.checklistToEdit = checklist;
    
    [self presentViewController:navigationController animated:YES completion:nil];

}
#pragma - mark ListDetailViewControllerDelegate
- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist {
    NSInteger newRowIndex = [self.dataModel.lists count];
    [self.dataModel.lists addObject:checklist];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist {
    NSInteger index = [self.dataModel.lists indexOfObject:checklist];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text= checklist.name;
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
