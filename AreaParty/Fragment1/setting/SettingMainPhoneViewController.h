//
//  SettingMainPhoneViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingMainPhoneHandler;
@interface SettingMainPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *setting_codeMainP;
@property (weak, nonatomic) IBOutlet UIButton *getChangeMainPCodeBtn;
- (IBAction)Press_sendChangeMainPBtn:(id)sender;
- (IBAction)Press_sendCode:(id)sender;
+(SettingMainPhoneHandler*) getHandler;
@end
