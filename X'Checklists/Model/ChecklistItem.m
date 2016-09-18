//
//  ChecklistItem.m
//  X'Checklists
//
//  Created by takamashiro on 16/9/9.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"
#import <UIKit/UIKit.h>
@implementation ChecklistItem


- (id)init
{
    if ((self = [super init])) {
        self.itemID = [DataModel nextChecklistItemId];
    }
    return self;
}


- (void)toggleChecked
{
    self.checked = !self.checked;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init])
    {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemID = [aDecoder decodeIntegerForKey:@"ItemID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemID forKey:@"ItemID"];
}

- (void)scheduleNotification
{
    if (self.shouldRemind &&
        [self.dueDate compare:[NSDate date]] != NSOrderedAscending)
    {
        UILocalNotification *existingNotification = [self notificationForThisItem];
        if (existingNotification != nil) {
            //NSLog(@"Found an existing notification %@",existingNotification);
            [[UIApplication sharedApplication]
             cancelLocalNotification:existingNotification];
        }
        UILocalNotification *localNotification =
        [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName =
        UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{
                                       @"ItemID" : @(self.itemID) };
        [[UIApplication sharedApplication]
         scheduleLocalNotification:localNotification];
    }
}

- (UILocalNotification *)notificationForThisItem
{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemId"];
        
        if (number != nil && [number integerValue] == self.itemID) {
            return notification;
        }
    }
    return nil;
}

- (void)dealloc
{
    UILocalNotification *existingNotification = [self
                                                 notificationForThisItem];
    if (existingNotification != nil) {
        [[UIApplication sharedApplication]
         cancelLocalNotification:existingNotification];
    }
}


@end
