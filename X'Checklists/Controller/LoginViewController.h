//
//  LoginViewController.h
//  X'Checklists
//
//  Created by takamashiro on 2016/9/17.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGestureLockView.h"

typedef NS_ENUM(NSInteger,LoginShowType) {
    LoginShowType_NONE,
    LoginShowType_USER,
    LoginShowType_PASS
};

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet KKGestureLockView *lockView;
@property (nonatomic, assign) BOOL changePassword;
@property (nonatomic, assign) BOOL closePassword;
@end
