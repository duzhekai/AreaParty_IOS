//
//  SettingPwdViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SettingPwdViewController.h"
#import "SettingPwdHandler.h"
@interface SettingPwdViewController (){
    int daojishi;
}

@end
static SettingPwdHandler* mhandler;
@implementation SettingPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[[MyUIApplication getInstance] addUiViewController:self];
    mhandler = [[SettingPwdHandler alloc] initWithController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onclick:(id)sender {
    if(sender == _getChangePwdCodeBtn){
        NSString* oldPwd = _setting_oldPwd.text;
        NSString* newPwd = _setting_newPwd.text;
        if(oldPwd == nil || [oldPwd isEqualToString:@""]){
            [Toast ShowToast:@"请填写旧密码" Animated:YES time:2 context:self.view];
            return;
        }
        if(newPwd == nil || [newPwd isEqualToString:@""]){
            [Toast ShowToast:@"请填写新密码" Animated:YES time:2 context:self.view];
            return;
        }
        if(![self isKeyWord:oldPwd]) {
            [Toast ShowToast:@"请按规则正确填写旧密码" Animated:YES time:2 context:self.view];
            return;
        }
        if(![self isKeyWord:newPwd]){
            [Toast ShowToast:@"请按规则正确填写新密码" Animated:YES time:2 context:self.view];
            return;
        }
        [NSThread detachNewThreadWithBlock:^(void){
            @try{
                SendCodeSync* builder = [[SendCodeSync alloc] init];
                [builder setChangeType:SendCodeSync_ChangeType_Password];
                NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_SendCode packetBytes:[builder data]];
                [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
            }@catch (NSException* e){
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            daojishi = 60;
            [_getChangePwdCodeBtn setEnabled:NO];
            [_getChangePwdCodeBtn setTitle:[NSString stringWithFormat:@"%d 秒",daojishi] forState:UIControlStateNormal];
            //倒计时
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer* timer){
                daojishi = daojishi-1;
                if(daojishi == 0){
                    [_getChangePwdCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [_getChangePwdCodeBtn setEnabled:YES];
                    [timer invalidate];
                }
                else{
                    [_getChangePwdCodeBtn setTitle:[NSString stringWithFormat:@"%d 秒",daojishi] forState:UIControlStateNormal];
                }
            }];
        });
    }
    else if(sender == _sendChangeMsgBtn){
        NSString* oldPwd1 = _setting_oldPwd.text;
        NSString* newPwd1 = _setting_newPwd.text;
        NSString* confirmCode =  _setting_codePwd.text;
        if(oldPwd1 == nil || [oldPwd1 isEqualToString:@""]){
            [Toast ShowToast:@"请填写旧密码" Animated:YES time:2 context:self.view];
            return;
        }
        if(newPwd1 == nil || [newPwd1 isEqualToString:@""]){
            [Toast ShowToast:@"请填写新密码" Animated:YES time:2 context:self.view];
            return;
        }
        if(![self isKeyWord:oldPwd1]) {
            [Toast ShowToast:@"请按规则正确填写旧密码" Animated:YES time:2 context:self.view];
            return;
        }
        if(![self isKeyWord:newPwd1]){
            [Toast ShowToast:@"请按规则正确填写新密码" Animated:YES time:2 context:self.view];
            return;
        }
        if(confirmCode == nil || [confirmCode isEqualToString:@""]){
            [Toast ShowToast:@"请填写验证码" Animated:YES time:2 context:self.view];
            return;
        }
        [NSThread detachNewThreadWithBlock:^(void){
                @try{
                    PersonalSettingsReq* builder = [[PersonalSettingsReq alloc] init];
                    [builder setCode:[confirmCode intValue]];
                    [builder setUserPassword:newPwd1];
                    [builder setUserOldPassword:oldPwd1];
                    NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_PersonalsettingsReq packetBytes:[builder data]];
                    [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
                }@catch (NSException* e){
                }
        }];
    }
}
+ (SettingPwdHandler*) getHandler {
    return mhandler;
}

- (BOOL) isKeyWord:(NSString*) kw{
    NSRange range = [kw rangeOfString:@"^([A-Z]|[a-z]|[0-9]|[`~!@#$%^&*()+=|{}':;',\\\\\\\\[\\\\\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]){6,20}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}
@end
