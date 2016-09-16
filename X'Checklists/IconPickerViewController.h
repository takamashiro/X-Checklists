//
//  IconPickerViewController.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/15.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IconPickerViewController;
@protocol IconPickerViewControllerDelegate <NSObject>

- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController
@property (nonatomic, assign) id<IconPickerViewControllerDelegate> delegate;
@end
