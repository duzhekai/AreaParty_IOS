//
//  RegisterPersonalInfo.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/6.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "RegisterPersonalInfo.h"
#import "CityPickerViewController.h"
#import "RegisterFinish.h"
@interface RegisterPersonalInfo (){
    NSString* userId;
    NSString* userName;
    NSString* userKeyword;
    NSString* userMobile;
    NSString* inputCode;
    BOOL isSendCode;
    int daojishi;
}

@end

@implementation RegisterPersonalInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    isSendCode = NO;
    // Do any additional setup after loading the view.
    //按钮
    _btn_register.backgroundColor = [UIColor colorWithRed:60/255.0f green:175/255.0f blue:250/255.0f alpha:1.0];
    _btn_register.layer.cornerRadius = 5;
    _btn_send_code.backgroundColor = [UIColor colorWithRed:60/255.0f green:175/255.0f blue:250/255.0f alpha:1.0];
    _btn_send_code.layer.cornerRadius = 5;
    NSLog(@"id:%@ name: %@ kw: %@",userId,userName,userKeyword);
    //初始化控件事件

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"pushpickerview"]){
    CityPickerViewController* targetvc = (CityPickerViewController*)[segue destinationViewController];
    RegisterPersonalInfo* this = (RegisterPersonalInfo*)sender;
        targetvc.fathervc =this;
    }
    else if([[segue identifier] isEqualToString:@"pushfinishview"]){
        RegisterFinish* target = (RegisterFinish*)[segue destinationViewController];
        NSDictionary* dic = (NSDictionary*)sender;
        target.userId = [dic objectForKey:@"userId"];
        target.psw = [dic objectForKey:@"psw"];
    }
}

- (BOOL) isMobileNO:(NSString*) mobiles{
    NSRange range = [mobiles rangeOfString:@"^((13[0-9])|(15[^4])|(18[0,2,3,5-9])|(17[0-8])|(147))\\d{8}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}
- (BOOL) isUserCode:(NSString*) code{
    NSRange range = [code rangeOfString:@"^\\d{6}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (IBAction)Press_btn_register:(UIButton *)sender {
    inputCode = _et_userCode.text;
    userMobile = _et_mobileNo.text;
    NSString* userAddress = _btn_selectAddress.titleLabel.text;
    NSString* userStreet = _et_userStreet.text;
    NSString* userCommunity =_et_userCommunity.text;
    NSString* mobile = _et_mobileNo.text;
    NSString* code = _et_userCode.text;
    if([userAddress isEqualToString:@"点击选择所在区域"]){
        [Toast ShowToast:@"请选择您当前所在地" Animated:YES time:2 context:self.view];
        return;
    }
    if([userStreet isEqualToString:@""]){
        [Toast ShowToast:@"请填写您居住地所在街道" Animated:YES time:2 context:self.view];
        return;
    }
    if([userCommunity isEqualToString:@""]){
        [Toast ShowToast:@"请填写您居住所在地所在小区" Animated:YES time:2 context:self.view];
        return;
    }
    if([mobile isEqualToString:@""]){
        [Toast ShowToast:@"请填写手机号" Animated:YES time:2 context:self.view];
        return;
    }
    if(![self isMobileNO:mobile]){
        [Toast ShowToast:@"请正确填写手机号" Animated:YES time:2 context:self.view];
        return;
    }
    if([code isEqualToString:@""]){
        [Toast ShowToast:@"请填写验证码" Animated:YES time:2 context:self.view];
        return;
    }
    if(![self isUserCode:code]){
        [Toast ShowToast:@"请正确填写验证码" Animated:YES time:2 context:self.view];
        return;
    }
    [NSThread detachNewThreadSelector:@selector(register) toTarget:self withObject:nil];
}

- (IBAction)Press_btn_selectAddress:(UIButton *)sender {
    [self performSegueWithIdentifier:@"pushpickerview" sender:self];
}

- (IBAction)Press_btn_sendcode:(UIButton *)sender {
    NSString* mobile =_et_mobileNo.text;
    if(![self isMobileNO:mobile]){
        [Toast ShowToast:@"请正确填写手机号" Animated:YES time:2 context:self.view];
    }
    if([self isMobileNO:mobile]){
        [NSThread detachNewThreadWithBlock:^{
            SendCodeSync* scsbuilder = [[SendCodeSync alloc] init];
            [scsbuilder setChangeType:SendCodeSync_ChangeType_Register];
            [scsbuilder setMobile:mobile];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSUInteger port = [defaults integerForKey:@"SERVER_PORT"];
            NSString*  host = [defaults objectForKey:@"SERVER_IP"];
            Base* base  = [[Base alloc] initWithHost:host andPort:(int)port];
            NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_SendCode packetBytes:[scsbuilder data]];
            [base writeToServer:base.outputStream arrayBytes:byteArray];
            [base close];
            dispatch_async(dispatch_get_main_queue(), ^{
                daojishi = 60;
                [_btn_send_code setEnabled:NO];
                [_btn_send_code setTitle:[NSString stringWithFormat:@"%d 秒",daojishi] forState:UIControlStateNormal];
                //倒计时
                [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer* timer){
                    daojishi = daojishi-1;
                    if(daojishi == 0){
                        [_btn_send_code setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [_btn_send_code setEnabled:YES];
                        [timer invalidate];
                    }
                    else{
                        [_btn_send_code setTitle:[NSString stringWithFormat:@"%d 秒",daojishi] forState:UIControlStateNormal];
                    }
                }];
            });
        }];
    }
}

-(void) register{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger port = [defaults integerForKey:@"SERVER_PORT"];
    NSString*  host = [defaults objectForKey:@"SERVER_IP"];
    NSLog(@"host:%@ port:%ld",host,port);
    RegisterReq * reqbuilder = [[RegisterReq alloc] init];
    [reqbuilder setRequestCode:RegisterReq_RequestCode_Checkmobile];
    [reqbuilder setUserMobile:userMobile];
    [reqbuilder setRegisterCode:(int32_t)[inputCode integerValue]];
    
    Base* base = [[Base alloc] initWithHost:host andPort:(int)port];
    NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_RegisterReq packetBytes:[reqbuilder data]];
    [base writeToServer:base.outputStream arrayBytes:byteArray];
    byteArray = [base readFromServer:base.inputStream];
    const Byte* byteArray_b = [byteArray bytes];
    if(byteArray.length ==0){
        //send message 0
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"网路中断，请检查网络" Animated:YES time:2 context:self.view];
        });
        [base close];
        return;
    }
    int size = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:0];
    int type = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:4];
    int objlength =size - [NetworkPacket getMessageObjectStartIndex];
    if(type == ENetworkMessage_RegisterRsp){
        Byte objBytes[objlength];
        for(int i =0; i<objlength ;i++){
            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex]+i];
        }
        RegisterRsp* response = [RegisterRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        if(response.resultType == RegisterRsp_ResultType_Mobile){
            if(response.resultCode == RegisterRsp_ResultCode_Success){
                [reqbuilder setRequestCode:RegisterReq_RequestCode_Register];
                [reqbuilder setUserId:userId];
                [reqbuilder setUserPassword:userKeyword];
                [reqbuilder setUserName:userName];
                [reqbuilder setUserMobile:userMobile];
                [reqbuilder setUserMac:[self getMacAddress]];
                [reqbuilder setUserAddress:_btn_selectAddress.titleLabel.text];
                [reqbuilder setUserStreet:_et_userStreet.text];
                [reqbuilder setUserCommunity:_et_userCommunity.text];
                byteArray = [NetworkPacket packMessage:ENetworkMessage_RegisterReq packetBytes:[reqbuilder data]];
                [base writeToServer:base.outputStream arrayBytes:byteArray];
                byteArray = [base readFromServer:base.inputStream];
                byteArray_b = [byteArray bytes];
                if(byteArray.length ==0){
                    //send message 0
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Toast ShowToast:@"网路中断，请检查网络" Animated:YES time:2 context:self.view];
                    });
                    [base close];
                    return;
                }
                size = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:0];
                type = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:4];
                objlength =size - [NetworkPacket getMessageObjectStartIndex];
                if(type == ENetworkMessage_RegisterRsp){
                    Byte objBytes[objlength];
                    for(int i =0; i<objlength ;i++){
                        objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex]+i];
                    }
                    response = [RegisterRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
                    if(response.resultType == RegisterRsp_ResultType_Register){
                        if(response.resultCode == RegisterRsp_ResultCode_Success){
                            [defaults setObject:[self getMacAddress] forKey:@"USER_MAC"];
                            //SEND MESSAGE 2
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSDictionary* dic = @{@"userId":userId,@"psw":userKeyword};
                                [self performSegueWithIdentifier:@"pushfinishview" sender:dic];
                            });
                            [base close];
                        }
                        else if(response.resultCode == RegisterRsp_ResultCode_Exist){
                            //send message 4
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [Toast ShowToast:@"该用户名或手机号已被注册" Animated:YES time:2 context:self.view];
                            });
                            [base close];
                        }
                    }
                }
            }else if(response.resultCode == RegisterRsp_ResultCode_Exist){
                //send message 3
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast ShowToast:@"该手机号已被注册" Animated:YES time:2 context:self.view];
                });
                [base close];
            }
            else if(response.resultCode == RegisterRsp_ResultCode_Codewrong){
                //send message 5
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast ShowToast:@"验证码错误" Animated:YES time:2 context:self.view];
                });
                [base close];
            }
        }
    }
    
}
- (void)setuserid:(NSString*) uid{
    userId = uid;
}
- (void)setusername:(NSString*) uname{
    userName = uname;
}
- (void)setkeyword:(NSString*) kw{
    userKeyword = kw;
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_et_mobileNo resignFirstResponder];
    [_et_userCode resignFirstResponder];
    [_et_userStreet resignFirstResponder];
    [_et_userCommunity resignFirstResponder];
}
- (void)onUIControllerResultWithCode:(int)resultCode andData:(NSDictionary *)data{
    [self.btn_selectAddress setTitle:[data objectForKey:@"address"] forState:UIControlStateNormal];
    [self.btn_selectAddress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
@end
