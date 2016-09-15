//
//  Checklist.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/11.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "Checklist.h"
#import "ChecklistItem.h"
@implementation Checklist
- (instancetype)init{
    if (self = [super init]) {
        self.items = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}


- (instancetype)initWithName:(NSString *)name{
    if (self = [self init]) {
        self.name = name;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
}

- (NSInteger)countUncheckedItems {
    NSInteger count = 0;
    
    for (ChecklistItem *item in self.items) {
        if (!item.checked) {
            count += 1;
        }
    }
    
    return count;
}

- (NSComparisonResult)compare:(Checklist *)otherChecklist
{
    return [self.name localizedStandardCompare: otherChecklist.name];
}

@end
