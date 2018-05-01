//
//  SettingNameHandler.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SettingNameHandler.h"
#import "SettingNameViewController.h"
@implementation SettingNameHandler
- (instancetype)initWithController:(SettingNameViewController*) controller{
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
                [Toast ShowToast:@"修改成功" Animated:YES time:2 context:_ctl.view];
                NSDictionary* message =  [NSDictionary dictionaryWithObjectsAndKeys:_ctl.setting_name_et.text,@"data",[NSNumber numberWithInt:OrderConst_setUserName],@"what",nil];
                [MainTabbarController_handlerTab01 onHandler:message];
                [_ctl dismissViewControllerAnimated:YES completion:nil];
            });
            break;
        }
        default:
            break;
    }
}
@end
