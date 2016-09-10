//
//  ChecklistItem.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/9.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "ChecklistItem.h"

@implementation ChecklistItem

- (instancetype)init {
    if (self = [super init]) {
        self.text = @"";
        self.checked = false;
    }
       return self;
}

- (void)toggleChecked
{
    self.checked = !self.checked;
}
@end
