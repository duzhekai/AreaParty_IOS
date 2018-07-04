//
//  SettingMainPhoneHandler.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SettingMainPhoneHandler.h"
#import "Toast.h"

@implementation SettingMainPhoneHandler
- (instancetype)initWithController:(SettingMainPhoneViewController*) controller{
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
                [Toast ShowToast:@"验证码错误" Animated:YES time:2 context:_ctl.view];
            });
            break;
        }
        default:
            break;
    }
}
@end
