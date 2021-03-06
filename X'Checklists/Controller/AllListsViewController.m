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
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonnull,strong) UILabel *label;
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
        
//        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:controller];
//        self.animator.dragable = NO;
//        self.animator.direction = ZFModalTransitonDirectionBottom;
//        [self.animator setContentScrollView:controller.tableView];
//        controller.transitioningDelegate = self.animator;
//        controller.modalPresentationStyle = UIModalPresentationCustom;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            controller.checklistToEdit = nil;
        }

    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    NSInteger index = self.dataModel.indexOfSelectedChecklist;
    
    
    if (index >= 0 &&index < self.dataModel.lists.count) {
        Checklist *checklist = self.dataModel.lists[index];
        [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    }

    [self updateFooterLabel];
    //[self.tableView reloadData];
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
    
    NSInteger count = checklist.countUncheckedItems;
    
    if (checklist.items.count == 0) {
        cell.detailTextLabel.text = @"(No Items)";
    }else if (count == 0) {
        cell.detailTextLabel.text = @"All Done!";
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd Remaining",count];
    }
    cell.imageView.image = [UIImage imageNamed:checklist.iconName];
    [self updateFooterLabel];
    return cell;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell) {
        return cell;
    } else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];

    Checklist *checklist = self.dataModel.lists[indexPath.row];
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

    [self updateFooterLabel];
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
    [self.dataModel sortChecklists];
    //[self.tableView reloadData];//整张表刷新
//   单行刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist {
    [self.dataModel sortChecklists];
    [self.tableView reloadData];//整张表刷新

//    NSInteger index = [self.dataModel.lists indexOfObject:checklist];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.textLabel.text= checklist.name;
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma -mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [self.dataModel setIndexOfSelectedChecklist: -1];
    }
}

- (void)setupFooterLabel{
    self.label = [[UILabel alloc] init];
    self.label.frame = CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width,50);
    [self.tableView.tableFooterView addSubview:self.label];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor lightTextColor];
    UIFont *font = [UIFont systemFontOfSize:19.0];
    self.label.font = font;
    
}
- (void)updateFooterLabel {
    if (_label == nil) {
        [self setupFooterLabel];
    }
    if (self.dataModel.lists.count == 0) {
        self.label.text = @"还没有列表哦，点右上小加号添加一个吧";
    }else {
        self.label.text = [NSString stringWithFormat:@"%zd个列表",self.dataModel.lists.count];
        
    }

}
@end
