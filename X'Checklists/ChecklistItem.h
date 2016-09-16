//
//  ChecklistItem.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/9.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject<NSCoding>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, assign) BOOL shouldRemind;
@property (nonatomic, assign) NSInteger itemID;
- (void)toggleChecked;
@end
