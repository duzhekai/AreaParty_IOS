//
//  SettingMainViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/4.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingNavigationVC.h"
#import "Update_ReceiveMsgBean.h"
#import "MyUIApplication.h"
#import "Toast.h"
#import "LoginViewController.h"
@interface SettingMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bottom_view;
@property (weak, nonatomic) IBOutlet UIView *top_view;
@property (weak, nonatomic) IBOutlet UIView *logout_view;
@property (weak, nonatomic) IBOutlet UIButton *changeUserNameLL;
@property (weak, nonatomic) IBOutlet UIButton *changeUserAddressLL;
@property (weak, nonatomic) IBOutlet UIButton *changeUserPwdLL;
@property (weak, nonatomic) IBOutlet UIButton *updateVersionLL;
@property (weak, nonatomic) IBOutlet UILabel *mnewVersionInforTV;
@property (weak, nonatomic) IBOutlet UIButton *logoutLL;
@property (weak, nonatomic) IBOutlet UIButton *changMainPhone_LL;
@property (weak, nonatomic) IBOutlet UIView *changMainPhone_Wrap;

@property (assign,nonatomic) BOOL outline;
- (IBAction)onclick:(id)sender;
@end
