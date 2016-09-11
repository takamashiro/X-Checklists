//
//  Checklist.h
//  X'Checklists
//
//  Created by takamashiro on 16/9/11.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checklist : NSObject

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name;
@end
