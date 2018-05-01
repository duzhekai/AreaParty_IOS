//
//  SettingPwdHandler.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SettingPwdHandler.h"

@implementation SettingPwdHandler
- (instancetype)initWithController:(SettingPwdViewController*) controller{
    self = [super init];
    if(self){
        _ctl = controller;
    }
    return self;
}
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
        case 0:{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [Toast ShowToast:@"修改失败，请重试" Animated:YES time:2 context:_ctl.view];
            });
            break;
        }
        case 1:{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [Toast ShowToast:@"修改成功，请重新登录" Animated:YES time:2 context:_ctl.view];
            });
            break;
        }
        case 2:{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [Toast ShowToast:@"旧密码错误，请重新输入" Animated:YES time:2 context:_ctl.view];
                [_ctl.setting_oldPwd setText:@""];
            });
            break;
        }
        case 3:{
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [Toast ShowToast:@"修改成功，请重新登录" Animated:YES time:2 context:_ctl.view];
                @try {
                    [Login_base close];
                } @catch (NSException* e) {
                }
                [[MyUIApplication getInstance] closeAll];
            });
            break;
        }
        default:
            break;
    }
}
@end
