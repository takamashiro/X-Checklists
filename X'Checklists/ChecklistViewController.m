//
//  ViewController.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/9.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "ChecklistViewController.h"
#import "ChecklistItem.h"


@interface ChecklistViewController ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation ChecklistViewController

- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    ChecklistItem *item1 = [[ChecklistItem alloc] init];
//    item1.text = @"Walk the dog";
//    item1.checked = false;
//    [self.items addObject:item1];
//    
//    ChecklistItem *item2 = [[ChecklistItem alloc] init];
//    item2.text = @"Brush my teeth";
//    item2.checked = false;
//    [self.items addObject:item2];
//    
//    ChecklistItem *item3 = [[ChecklistItem alloc] init];
//    item3.text = @"Learn iOS development";
//    item3.checked = true;
//    [self.items addObject:item3];
//    
//    ChecklistItem *item4 = [[ChecklistItem alloc] init];
//    item4.text = @"Soccer practice";
//    item4.checked = false;
//    [self.items addObject:item4];
//    
//    ChecklistItem *item5 = [[ChecklistItem alloc] init];
//    item5.text = @"Eat ice cream";
//    item5.checked = false;
//    [self.items addObject:item5];

    self.tableView.rowHeight = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigation = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigation.topViewController;
        controller.delegate = self;
    }else if([segue.identifier isEqualToString:@ "EditItem"]) {
        UINavigationController *navigation = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigation.topViewController;
        controller.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            controller.itemToEdit = self.items[indexPath.row];
        }
    
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentified = @"ChecklistItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentified];
   
    ChecklistItem *item = self.items[indexPath.row];
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    return cell;
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = [NSString stringWithFormat:@"%@",item.text];
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
    label.textColor = self.view.tintColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item = self.items[indexPath.row];
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
}

#pragma -mark ItemDetailViewControllerDelegate
- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item {
    
    NSInteger newRowIndex = self.items.count;
    [self.items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item {
    
    NSInteger index = [self.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
