//
//  DataModel.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/14.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Checklist.h"
@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray<Checklist *> *lists;
@property (nonatomic, assign) NSInteger indexOfSelectedChecklist;
- (void)saveChecklists;
- (void)loadChecklists;
@end
