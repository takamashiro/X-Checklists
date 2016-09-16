//
//  IconPickerViewController.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/15.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "IconPickerViewController.h"

@interface IconPickerViewController ()
@property (nonatomic, strong) NSArray *icons;
@end

@implementation IconPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.icons = @[ @"No Icon",
                  @"Appointments", @"Birthdays", @"Chores", @"Drinks", @"Folder", @"Groceries", @"Inbox", @"Photos", @"Trips" ];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.icons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"IconCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *iconName = self.icons[indexPath.row];
    cell.textLabel.text = iconName;
    cell.imageView.image = [UIImage imageNamed:iconName];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iconName = self.icons[indexPath.row];
    [self.delegate iconPicker:self didPickIcon:iconName];
}
@end
