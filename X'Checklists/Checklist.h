//
//  Checklist.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/11.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChecklistItem;

@interface Checklist : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray<ChecklistItem *> *items;
- (instancetype)initWithName:(NSString *)name;

@end
