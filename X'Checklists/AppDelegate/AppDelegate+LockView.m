//
//  AppDelegate+LockView.m
//  X'Checklists
//
//  Created by takamashiro on 2016/9/17.
//  Copyright © 2016年 takamashiro. All rights reserved.
//

#import "AppDelegate+LockView.h"
#import "LoginViewController.h"
@implementation AppDelegate (LockView)

- (void)gestureLockApplicationDidBecomeActive:(UIApplication *)application {
    [self showGestureLockView];
}

- (void)showGestureLockView {
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    BOOL showLoginView = [userDefaults boolForKey:@"loginViewStatus"];
//    
//    if (showLoginView) {
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    //}
}
@end
