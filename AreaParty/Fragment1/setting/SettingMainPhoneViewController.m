//
//  SettingMainPhoneViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SettingMainPhoneViewController.h"
#import "SendCode.pbobjc.h"
#import "LoginViewController.h"
#import "PersonalSettingsMsg.pbobjc.h"
#import "SettingMainPhoneHandler.h"

@interface SettingMainPhoneViewController (){
    int daojishi;
}

@end
static SettingMainPhoneHandler* mhandler;
@implementation SettingMainPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mhandler = [[SettingMainPhoneHandler alloc] initWithController:self];
    
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

- (IBAction)Press_sendChangeMainPBtn:(id)sender {
    NSString* code = _setting_codeMainP.text;
    if([code isEqualToString:@""]){
        [Toast ShowToast:@"请填写验证码" Animated:YES time:1 context:self.view];
        return;
    }
    if(![self isUserCode:code]){
        [Toast ShowToast:@"请正确填写验证码" Animated:YES time:1 context:self.view];
        return;
    }
    [NSThread detachNewThreadWithBlock:^{
        @try{
            PersonalSettingsReq* builder = [[PersonalSettingsReq alloc] init];
            builder.code = [code intValue];
            builder.userId = Login_userId;
            builder.userMainMac = [self getMacAddress];
            NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_PersonalsettingsReq packetBytes:[builder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
        }@catch (NSException* e){
        }
    }];
}
- (IBAction)Press_sendCode:(id)sender {
    [NSThread detachNewThreadWithBlock:^{
        @try {
            SendCodeSync* builder = [[SendCodeSync alloc] init];
            builder.changeType = SendCodeSync_ChangeType_Mainphone;
            builder.userId = Login_userId;
            NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_SendCode packetBytes:[builder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
        } @catch (NSException* e) {
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            daojishi = 60;
            [_getChangeMainPCodeBtn setEnabled:NO];
            [_getChangeMainPCodeBtn setTitle:[NSString stringWithFormat:@"%d 秒",daojishi] forState:UIControlStateNormal];
            //倒计时
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer* timer){
                daojishi = daojishi-1;
                if(daojishi == 0){
                    [_getChangeMainPCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [_getChangeMainPCodeBtn setEnabled:YES];
                    [timer invalidate];
                }
                else{
                    [_getChangeMainPCodeBtn setTitle:[NSString stringWithFormat:@"%d 秒",daojishi] forState:UIControlStateNormal];
                }
            }];
        });
    }];
}
- (BOOL) isUserCode:(NSString*) code{
    NSRange range = [code rangeOfString:@"^\\d{6}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}
- (NSString *)getMacAddress {
         int mib[6];
         size_t len;
         char *buf;
         unsigned char *ptr;
         struct if_msghdr *ifm;
         struct sockaddr_dl *sdl;
         
         mib[0] = CTL_NET;
         mib[1] = AF_ROUTE;
         mib[2] = 0;
         mib[3] = AF_LINK;
         mib[4] = NET_RT_IFLIST;
         
         if ((mib[5] = if_nametoindex("en0")) == 0) {
             printf("Error: if_nametoindex error/n");
             return NULL;
         }
         
         if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
             printf("Error: sysctl, take 1/n");
             return NULL;
         }
         
         if ((buf = malloc(len)) == NULL) {
             printf("Could not allocate memory. error!/n");
             return NULL;
         }
         
         if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
             free(buf);
             printf("Error: sysctl, take 2");
             return NULL;
         }
         
         ifm = (struct if_msghdr *)buf;
         sdl = (struct sockaddr_dl *)(ifm + 1);
         ptr = (unsigned char *)LLADDR(sdl);
         
         // MAC地址带冒号
         NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2),*(ptr+3), *(ptr+4), *(ptr+5)];
         free(buf);
         return [outstring lowercaseString];
     }
+(SettingMainPhoneHandler*) getHandler{
    return mhandler;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_setting_codeMainP resignFirstResponder];
}
@end
