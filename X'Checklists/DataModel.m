//
//  DataModel.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/14.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (instancetype)init {
    if (self = [super init]) {
        self.lists = [[NSMutableArray alloc] initWithCapacity:20];
        [self loadChecklists];
    }
    return self;
}
#pragma -mark  persist - file manager

- (NSString *)documentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDiretory = [paths firstObject];
    return documentsDiretory;
}


- (NSString *)dataFilePath {
    
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
}

- (void)saveChecklists {
    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklists{
    
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if(data) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc ]initForReadingWithData:data];
            self.lists = [unarchiver decodeObjectForKey:@"Checklists"];
            
            [unarchiver finishDecoding];
        }
    }
}
@end
