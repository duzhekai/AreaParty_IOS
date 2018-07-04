//
//  LoginByVerificationCode.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "LoginByVerificationCode.h"
@interface LoginByVerificationCode (){
    long timer ;
    BOOL outline ;
    NSInteger mport;
    NSString* mhost;
    NSUserDefaults *defaults;
    LoginReq* builder;
    int daojishi;
}

@end
@implementation LoginByVerificationCode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timer =0;
    outline = NO;
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //设置navigationbar的文字和颜色
    self.navigationItem.title = @"验证码登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _mLoginButton.backgroundColor = [UIColor colorWithRed:60/255.0f green:175/255.0f blue:250/255.0f alpha:1.0];
    _mLoginButton.layer.cornerRadius = 5;
    _btn_send_code.backgroundColor = [UIColor colorWithRed:60/255.0f green:175/255.0f blue:250/255.0f alpha:1.0];
    _btn_send_code.layer.cornerRadius = 5;
    
    defaults = [NSUserDefaults standardUserDefaults];
}
-(void)login{
    Login_userMac= [defaults stringForKey:@"USER_MAC"];
    Login_userId  = _et_mobileNo.text;
    NSString* code = _et_userCode.text;
    if(Login_userMac==nil || [Login_userMac isEqualToString:@""]){
        Login_userMac = [self getMacAddress];
        if(Login_userMac!= nil){
        [defaults setObject:Login_userMac forKey:@"USER_MAC"];
        }
    }
    builder = [[LoginReq alloc] init];
    [builder setUserId:Login_userId];
    [builder setUserCode:code];
    [builder setLoginType:LoginReq_LoginType_MobileCode];
    [builder setUserMac:Login_userMac];
    
    @try{
        Login_base = [[Base alloc] initWithHost:mhost andPort: (int)mport];
        NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_LoginReq packetBytes:[builder data]];
        [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
        byteArray = [Login_base readFromServer:Login_base.inputStream];
        if([byteArray length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"what"]];
                Login_userId =@"";
                [Login_base close];
            });
            return;
        }
        const Byte * byteArray_b = [byteArray bytes];
        int size = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:0];
        int type = [DataTypeTranslater bytesToInt:(Byte*)byteArray_b offset:4];
        int objlength =size- [NetworkPacket getMessageObjectStartIndex];
        if(type == ENetworkMessage_LoginRsp){
            Byte objByte[objlength];
            for(int i =0;i<objlength;i++){
                objByte[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex]+i];
            }
            LoginRsp* response = [LoginRsp parseFromData:[NSData dataWithBytes:objByte length:objlength] error:nil];
            NSLog(@"%d",response.resultCode);
            if(response.resultCode == LoginRsp_ResultCode_Fail){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:11] forKey:@"what"]];
                    Login_userId=@"";
                    [Login_base close];
                });
                return;
            }
            else if (response.resultCode == LoginRsp_ResultCode_Usercodewrong){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"what"]];
                    Login_userId =@"";
                    [Login_base close];
                });
                return;
            }
            else if(response.resultCode == LoginRsp_ResultCode_Loggedin){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:7] forKey:@"what"]];
                    Login_userId=@"";
                    [Login_base close];
                });
                return;
            }
            else if(response.resultCode == LoginRsp_ResultCode_Notmainphone){
                //此处弹出对话框，告诉用户等待授权
                [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:8] forKey:@"what"]];
                BOOL accreditMsg = NO;
                while(!accreditMsg){
                    byteArray = [Login_base readFromServer:Login_base.inputStream];
                    byteArray_b = [byteArray bytes];
                    size = [DataTypeTranslater bytesToInt:(Byte*)[byteArray bytes] offset:0];
                    type = [DataTypeTranslater bytesToInt:(Byte*)[byteArray bytes] offset:4];
                    int objlength = size - [NetworkPacket getMessageObjectStartIndex];
                    if(type == ENetworkMessage_AccreditRsp){
                        Byte objBytes[objlength];
                        for(int i =0;i<objlength;i++){
                            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex]+i];
                        }
                        AccreditRsp* accreditRespanse = [AccreditRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
                        if(accreditRespanse.resultCode == AccreditRsp_ResultCode_Responscode){
                            AccreditReq *accredit = [[AccreditReq alloc] init];
                            [accredit setAccreditCode:@"11"];
                            [accredit setAccreditMac:[self getMacAddress]];
                            [accredit setUserId:@"petter"];
                            [accredit setType:AccreditReq_Type_Require];
                            NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_AccreditReq packetBytes:[accredit data]];
                            [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
                        }
                        else if(accreditRespanse.resultCode == AccreditRsp_ResultCode_Canlogin){
                            byteArray = [NetworkPacket packMessage:ENetworkMessage_LoginReq packetBytes:[builder data]];
                            [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
                        }
                        else if(accreditRespanse.resultCode == AccreditRsp_ResultCode_Fail){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:10] forKey:@"what"]];
                                [Login_base close];
                            });
                            return;
                        }
                    }
                    else if(type == ENetworkMessage_LoginRsp){
                        Byte objBytes[objlength];
                        for(int i =0;i<objlength;i++){
                            objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex]+i];
                        }
                        response = [LoginRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
                        break;
                    }
                }
            }
            else if(response.resultCode == LoginRsp_ResultCode_Mainphoneoutline){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:9] forKey:@"what"]];
                    [Login_base close];
                });
                return;
            }
            if(response.mainMobileCode == LoginRsp_MainMobileCode_Yes){
                Login_mainMobile = YES;
            }
            else if(response.mainMobileCode == LoginRsp_MainMobileCode_No){
                Login_mainMobile = NO;
            }
            [Login_base.onlineUserId removeAllObjects];
            [Login_userFriend removeAllObjects];
            [Login_userNet removeAllObjects];
            [Login_userShare removeAllObjects];
            [Login_base.onlineUserId addObject:Login_userId];
            GroupItem* ggb = [[GroupItem alloc] init];
            ggb.groupName = @"全部好友";
            ggb.groupId = @"0";
            ggb.createrUserId = Login_userId;
            //用户分类
            NSMutableArray* lu = [response userItemArray];
            if([lu count]!=0){
                for(UserItem* u in lu){
                    if([u.userId isEqualToString:Login_userId]) continue;
                    if(u.isOnline){
                        [Login_base.onlineUserId addObject:u.userId];
                    }
                    if(u.isFriend){
                        [Login_userFriend addObject:u];
                        [ggb.memberUserIdArray addObject:u.userId];
                    }
                    if(u.isSpeed&&u.isFriend){
                        [Login_userNet addObject:u];
                    }
                    if(u.isRecommend){
                        [Login_userShare addObject:u];
                    }
                }
            }
            NSMutableArray* chats = response.chatItemArray;
            [Login_myChats setList:chats];
            
            NSArray<GroupItem*>* groups = response.groupItemArray;
            [Login_userGroups addObject:ggb];
            if(groups.count !=0) {
                for(GroupItem* g in groups) {
                    [Login_userGroups addObject:g];
                }
            }
            
            GetUserInfoReq* userBuilder = [[GetUserInfoReq alloc] init];
            [userBuilder.targetUserIdArray addObject:Login_userId];
            [userBuilder setFileInfo:YES];
            NSData* filebyteArray = [NetworkPacket packMessage:ENetworkMessage_GetUserinfoReq packetBytes:[userBuilder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:filebyteArray];
            byteArray = [Login_base readFromServer:Login_base.inputStream];
            byteArray_b = [byteArray bytes];
            size = [DataTypeTranslater bytesToInt:(Byte *)byteArray_b offset:0];
            
            type = [DataTypeTranslater bytesToInt:(Byte *)byteArray_b offset:4];
            
            if(type == ENetworkMessage_GetUserinfoRsp){
                int objlength = size - [NetworkPacket getMessageObjectStartIndex];
                Byte objBytes[objlength];
                for(int i =0; i < objlength;i++)
                    objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex]+i];
                GetUserInfoRsp* fileresponse = [GetUserInfoRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
                Login_userId = fileresponse.userItemArray[0].userId;
                Login_userName = fileresponse.userItemArray[0].userName;
                Login_userHeadIndex = fileresponse.userItemArray[0].headIndex;
                
                if(fileresponse.resultCode == GetUserInfoRsp_ResultCode_Success){
                    if([fileresponse.userItemArray[0].userId isEqualToString:Login_userId]){
                        //Login_files = fileresponse.filesArray;
                        NSDateFormatter* formartter = [[NSDateFormatter alloc] init];
                        [formartter setDateFormat:@"yyyy/MM/dd HH:mm"];
                        for(FileItem* file in Login_files){
                            [Login_files addObject:file];
                            SharedflieBean* sharedFile = [[SharedflieBean alloc] init];
                            sharedFile.mid = [file.fileId intValue];
                            sharedFile.name =file.fileName;
                            sharedFile.des = file.fileInfo;
                            sharedFile.size = [file.fileSize intValue];
                            long time = [file.fileDate longLongValue];
                            sharedFile.timeLong = time;
                            sharedFile.timeStr = [formartter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:(time/1000)]];
                            [MyUIApplication addMySharedFlies:sharedFile];
                        }
                    }
                }else{
                    //保留
                }
            }
            [[[NSThread alloc] initWithTarget:Login_base selector:@selector(listen) object:nil] start];
            //跳转主界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2] forKey:@"what"]];
            });
        }
    }@catch(NSException* e){
        NSLog(@"%@",e);
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        MainTabbarController* target = (MainTabbarController*)[segue destinationViewController];
        target.intentbundle = sender;
}


- (IBAction)press_send_code:(id)sender {
    NSString* mobile =_et_mobileNo.text;
    if(![self isMobileNO:mobile]){
        [Toast ShowToast:@"请正确填写手机号" Animated:YES time:2 context:self.view];
    }
    if([self isMobileNO:mobile]){
        [NSThread detachNewThreadWithBlock:^{
            SendCodeSync* scsbuilder = [[SendCodeSync alloc] init];
            [scsbuilder setChangeType:SendCodeSync_ChangeType_Login];
            [scsbuilder setMobile:mobile];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSUInteger port = [defaults integerForKey:@"SERVER_PORT"];
            NSString*  host = [defaults objectForKey:@"SERVER_IP"];
            if (host == nil || [host isEqualToString:@""]){
                host = [defaults stringForKey:@"SERVER_IP"];
                if(host == nil){
                    host = [MyUIApplication getAREAPARTY_NET];
                }
                if (host == nil){
                    host = [MyUIApplication getAREAPARTY_NET];
                    if (host == nil){
                        [NSThread detachNewThreadWithBlock:^{
                            [MyUIApplication setAREAPARTY_NET:[MyUIApplication GetInetAddress:[MyUIApplication getdomain]]];
                        }];
                        return;
                    }
                }
            }
            if (port == nil){
                port = [defaults integerForKey:@"SERVER_PORT"];
                if (port == nil){
                    port = 3333;
                }
            }
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
- (IBAction)press_mLoginButton:(id)sender {
    NSString* mobile = _et_mobileNo.text;
    NSString* code = _et_userCode.text;
    if([mobile isEqualToString:@""]){
        [Toast ShowToast:@"请填写手机号" Animated:YES time:1 context:self.view];
        return;
    }
    if (![self isMobileNO:mobile]) {
        [Toast ShowToast:@"请正确填写手机号" Animated:YES time:1 context:self.view];
        return;
    }
    if([code isEqualToString:@""]){
        [Toast ShowToast:@"请填写验证码" Animated:YES time:1 context:self.view];
        return;
    }
    if(![self isUserCode:code]){
        [Toast ShowToast:@"请正确填写验证码" Animated:YES time:1 context:self.view];
        return;
    }
    
    [self tryLogin];
}
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"]intValue]) {
        case 0:
//            btn_send_code.setBackgroundResource(R.drawable.disabledbuttonradius);
//            btn_send_code.setEnabled(false);
//            mc = new MyCount(60000, 1000);
//            mc.start();
            break;
        case 1:
            [Toast ShowToast:@"登录失败，验证码错误" Animated:YES time:1 context:self.view];
            break;
        case 2:
            
            //跳转主界面
                [self.navigationController performSegueWithIdentifier:@"pushMainView" sender:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"outline",
                                                                                              Login_userId,@"userId",
                                                                                              Login_userName,@"userName",
                                                                                              [NSNumber numberWithInt:Login_userHeadIndex],@"userHeadIndex",
                                                                                              Login_myChats,@"chats",
                                                                                              nil]];
            break;
        case 3:
            //跳转设置界面
        {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            [dic setObject:mhost forKey:@"ip"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)mport] forKey:@"port"];
            [self performSegueWithIdentifier:@"pushSettingView" sender:dic];
            break;
        }
            break;
        case 4:
            //离线登录
            outline = YES;
            break;
        case 5:
            //正常登录
            outline = YES;
            break;
        case 6:
            /*//接收用户注册后返回的用户名密码
             String s = (String) msg.obj;
             String userId = s.split(":")[0];
             String psw = s.split(":")[1];
             mAccount.setText(userId);
             mPwd.setText(psw);*/
            break;
        case 7:
            /*Toast.makeText(LoginByVerificationCode.this, "您的账号已登录", Toast.LENGTH_SHORT).show();*/
            break;
        case 8:
            //弹出提示框，告诉用户等待授权
            /*((TextView) accreditView.findViewById(R.id.accreditDialogTitle)).setText("等待主设备授权");
             ((TextView) accreditView.findViewById(R.id.accreditDialogInfo)).setText("请在注册该账号的设备上登录进行授权");
             ((Button) accreditView.findViewById(R.id.accreditDialogConfirm)).setOnClickListener(mListener);
             ((TextView)accreditView.findViewById(R.id.verificationBtn)).setVisibility(View.GONE);
             dialog.show();*/
            break;
        case 9:
            /*//弹出提示框，告诉用户主设备不在线
             ((TextView) accreditView.findViewById(R.id.accreditDialogTitle)).setText("主设备不在线");
             ((TextView) accreditView.findViewById(R.id.accreditDialogInfo)).setText("请打开主设备进行授权操作");
             ((Button) accreditView.findViewById(R.id.accreditDialogConfirm)).setOnClickListener(mListener);
             ((TextView)accreditView.findViewById(R.id.verificationBtn)).getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG);
             ((TextView)accreditView.findViewById(R.id.verificationBtn)).setVisibility(View.VISIBLE);
             ((TextView)accreditView.findViewById(R.id.verificationBtn)).setOnClickListener(new OnClickListener() {
             @Override
             public void onClick(View view) {
             startActivity(new Intent(Login.this,LoginByVerificationCode.class));
             if (dialog.isShowing()) dialog.dismiss();
             }
             });
             dialog.show();*/
            break;
        case 10:
            /*((TextView) accreditView.findViewById(R.id.accreditDialogTitle)).setText("授权失败");
             ((TextView) accreditView.findViewById(R.id.accreditDialogInfo)).setText("主设备拒绝授权您的手机使用该账号登录");
             ((Button) accreditView.findViewById(R.id.accreditDialogConfirm)).setOnClickListener(mListener);
             dialog.show();*/
            break;
        case 11:
            [Toast ShowToast:@"登录失败，该用户未注册" Animated:YES time:1 context:self.view];
            break;
        default:
            break;
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
- (void) tryLogin{
    NSDate *now = [NSDate date];
    if (mhost == nil || [mhost isEqualToString:@""]){
        mhost = [defaults stringForKey:@"SERVER_IP"];
        if(mhost == nil){
            mhost = [MyUIApplication getAREAPARTY_NET];
        }
        if (mhost == nil){
            mhost = [MyUIApplication getAREAPARTY_NET];
            if (mhost == nil){
                [NSThread detachNewThreadWithBlock:^{
                    [MyUIApplication setAREAPARTY_NET:[MyUIApplication GetInetAddress:[MyUIApplication getdomain]]];
                }];
                return;
            }
        }
    }
    if (mport == nil){
        mport = [defaults integerForKey:@"SERVER_PORT"];
        if (mport == nil){
            mport = 3333;
        }
    }
    if (outline == NO) {
        if ([now timeIntervalSince1970] - timer > 3) {
            @try {
                [NSThread detachNewThreadSelector:@selector(login) toTarget:self withObject:nil];
            } @catch (NSException* e) {
                NSLog(@"%@",e);
            }
            timer = [now timeIntervalSince1970];
        } else {
            [Toast ShowToast:@"正在登录" Animated:YES time:1 context:self.view];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_et_mobileNo resignFirstResponder];
    [_et_userCode resignFirstResponder];
}
@end
