//
//  LoginByVerificationCode.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
@interface LoginByVerificationCode : UIViewController<onHandler>
@property (weak, nonatomic) IBOutlet UIButton *btn_send_code;
- (IBAction)press_send_code:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *et_mobileNo;
@property (weak, nonatomic) IBOutlet UITextField *et_userCode;
@property (weak, nonatomic) IBOutlet UIButton *mLoginButton;
- (IBAction)press_mLoginButton:(id)sender;
@end
