//
//  LoginViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/10.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "LoginViewController.h"
#import "Base.h"
@interface LoginViewController (){
    long timer ;
    BOOL outline ;
    NSInteger mport;
    NSString* mhost;
    NSUserDefaults *defaults;
}

@end
//static变量
Base* Login_base;
NSMutableArray<UserItem*> *Login_userFriend;
NSMutableArray<UserItem*> *Login_userNet;
NSMutableArray<UserItem*> *Login_userShare;
NSMutableArray<FileItem*> *Login_files;
NSString* Login_userId;
NSString* Login_userName;
NSString* Login_userMac;
BOOL Login_mainMobile;
int Login_userHeadIndex;
myChatList* Login_myChats;

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    timer =0;
    outline =NO;
    Login_userFriend = [[NSMutableArray alloc] init];
    Login_userNet = [[NSMutableArray alloc] init];
    Login_userShare = [[NSMutableArray alloc] init];
    Login_files = [[NSMutableArray alloc] init];
    Login_myChats = [[myChatList alloc] init];
    NSLog(@"%@",Login_userFriend);
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //设置navigationbar的文字和颜色
    self.navigationItem.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    //设置 设置 按钮
    UIView* leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    UIImageView* leftimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting.png"]];
    leftimageview.frame = CGRectMake(0, 0, 23, 23);
    leftview.userInteractionEnabled=YES;
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressbtnsetting)];
    //将手势添加到需要相应的view中去
    [leftview addGestureRecognizer:tapGesture];
    [leftview addSubview:leftimageview];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftview];
    self.navigationItem.leftBarButtonItem= leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:0 target:self action:@selector(Press_register_btn)];
    //设置TF图标
    UIImageView *username_img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,30,30)];
    username_img.image=[UIImage imageNamed:@"ic_account.png"];
    _musernameTF.leftView=username_img;
    _musernameTF.leftViewMode=UITextFieldViewModeAlways;
    _musernameTF.backgroundColor = [UIColor clearColor];
    UIImageView *pwd_img=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,30,30)];
    pwd_img.image=[UIImage imageNamed:@"ic_password.png"];
    _mpasswdTF.leftView=pwd_img;
    _mpasswdTF.leftViewMode=UITextFieldViewModeAlways;
    _mpasswdTF.backgroundColor = [UIColor clearColor];
    //登录按钮
    _Login_btn.backgroundColor = [UIColor colorWithRed:60/255.0f green:175/255.0f blue:250/255.0f alpha:1.0];
    _Login_btn.layer.cornerRadius = 5;
    //设置导航栏左侧按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //TCPserver
    //Userdefault
    defaults = [NSUserDefaults standardUserDefaults];
    NSString* dftusername = [defaults stringForKey:@"USER_ID"];
    NSString* dftpwd =[defaults stringForKey:@"USER_PWD"];
    mport = [defaults integerForKey:@"SERVER_PORT"];
    mhost = [defaults stringForKey:@"SERVER_IP"];
    if( mport == nil){
        mport = 3333;
        //[defaults setInteger:3333 forKey:@"SERVER_PORT"];
    }
    if(mhost == nil){
        mhost = [MyUIApplication getAREAPARTY_NET];
        //[defaults setObject:[MyUIApplication getAREAPARTY_NET] forKey:@"SERVER_IP"];
    }
    if(mhost == nil){
        [MyUIApplication setAREAPARTY_NET:mhost];
    }
    [_musernameTF setText:dftusername];
    [_mpasswdTF setText:dftpwd];
    NSLog(@"%@",mhost);
    if([[[[PreferenceUtil alloc] init]readKey:@"isHelpDialogShow_launch"] isEqualToString:@"yes"]||[[[PreferenceUtil alloc] init]readKey:@"isHelpDialogShow_launch"] ==nil){
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Dialogs" bundle:nil] instantiateViewControllerWithIdentifier:@"ActionDialog_launch"] animated:YES completion:nil];
    }
}
- (UIAlertController *)alertController{
    if(_alertController ==nil){
        _alertController = [UIAlertController alertControllerWithTitle:@"等待主设备授权" message:@"请在注册该账号的设备上登录进行授权" preferredStyle:UIAlertControllerStyleAlert];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击确认");
            
        }]];
    }
    return _alertController;
}
- (void) tryLogin{
    NSDate *now = [NSDate date];
    if (mhost == nil  || [mhost isEqualToString:@""]){
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
    if([_musernameTF.text isEqualToString:@""]||[_mpasswdTF.text isEqualToString:@""]){
        [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"what"]];
        return;
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
-(void) pressbtnsetting{
    [self onHandler:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:3] forKey:@"what"]];
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
    if([[segue destinationViewController] isKindOfClass:[MainTabbarController class]]){
        MainTabbarController* target = (MainTabbarController*)[segue destinationViewController];
        target.intentbundle = sender;
    }
    else if([segue.identifier isEqualToString:@"pushSettingView"]){
        LoginSettingViewController* target = (LoginSettingViewController*)[segue destinationViewController];
        target.bundle = sender;
    }
}


- (IBAction)Press_login_btn:(UIButton *)sender {
    [self tryLogin];
}

- (IBAction)Press_offline_btn:(id)sender {
    Login_userId =@"";
  [self.navigationController performSegueWithIdentifier:@"pushMainView" sender:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"outline",nil]];
}

- (IBAction)Press_LoginByVerificationCode_btn:(id)sender {
    [self performSegueWithIdentifier:@"pushLoginByVerificationCode" sender:nil];
}

- (void)Press_register_btn{
    [self performSegueWithIdentifier:@"pushRegisterView" sender:nil];
}
-(NSString*) getPhoneInfo{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    return [@"Apple" stringByAppendingString:[NSString stringWithFormat:@" %@",platform]];
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
-(void)login{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    Login_userMac = [defaults stringForKey:@"USER_MAC"];
    Login_userId = _musernameTF.text;
    NSString* userPwd = _mpasswdTF.text;
    [defaults setObject:Login_userId forKey:@"USER_ID"];
    [defaults setObject:userPwd forKey:@"USER_PWD"];
    if(Login_userMac == nil){
        Login_userMac =[self getMacAddress];
        [defaults setObject:Login_userMac forKey:@"USER_MAC"];
    }
    if(Login_userId.length ==0 || userPwd.length == 0)
        [Toast ShowToast:@"请输入用户名密码" Animated:YES time:2 context:self.view];
    @try{
        Login_base = [[Base alloc] initWithHost:mhost andPort: (int)mport];
        LoginReq* loginreq = [[LoginReq alloc] init];
        [loginreq setUserId:Login_userId];
        [loginreq setUserPassword:userPwd];
        [loginreq setLoginType:LoginReq_LoginType_Mobile];
        [loginreq setUserMac:Login_userMac];
        [loginreq setMobileInfo:[self getPhoneInfo]];
        
        NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_LoginReq packetBytes:[loginreq data]];
        [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
        byteArray = [Login_base readFromServer:Login_base.inputStream];
        if([byteArray length]==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast ShowToast:@"用户名或密码错误" Animated:YES time:2 context:self.view];
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
                    [Toast ShowToast:@"用户名或密码错误" Animated:YES time:2 context:self.view];
                    Login_userId=@"";
                    [Login_base close];
                });
                return;
            }
            else if(response.resultCode == LoginRsp_ResultCode_Loggedin){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast ShowToast:@"您的账号已登录" Animated:YES time:2 context:self.view];
                    Login_userId=@"";
                    [Login_base close];
                });
                return;
            }
            else if(response.resultCode == LoginRsp_ResultCode_Notmainphone){
                //此处弹出对话框，告诉用户等待授权
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.alertController setTitle:@"等待主设备授权"];
                    [self.alertController setMessage:@"请在注册该账号的设备上登录进行授权"];
                    [self presentViewController: self.alertController animated:YES completion:nil];
                });
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
                            NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_LoginReq packetBytes:[loginreq data]];
                            [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
                        }
                        else if(accreditRespanse.resultCode == AccreditRsp_ResultCode_Fail){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if(self.alertController.isViewLoaded && self.alertController.view.window)
                                    [self.alertController dismissViewControllerAnimated:YES completion:^{
                                        [self.alertController setTitle:@"授权失败"];
                                        [self.alertController setMessage:@"主设备拒绝授权您的手机使用该账号进行登录"];
                                        [self presentViewController: self.alertController animated:YES completion:nil];
                                    }];
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
                        [self.alertController dismissViewControllerAnimated:YES completion:nil];
                        break;
                    }
                }
            }
            else if(response.resultCode == LoginRsp_ResultCode_Mainphoneoutline){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.alertController setTitle:@"主设备不在线"];
                    [self.alertController setMessage:@"请打开主设备进行授权操作"];
                    [self presentViewController: self.alertController animated:YES completion:nil];
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
                        Login_files = fileresponse.filesArray;
                        NSDateFormatter* formartter = [[NSDateFormatter alloc] init];
                        [formartter setDateFormat:@"yyyy/MM/dd HH:mm"];
                        for(FileItem* file in Login_files){
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
                [self.navigationController performSegueWithIdentifier:@"pushMainView" sender: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                              [NSNumber numberWithBool:NO],@"outline",
                                                                                              Login_userId,@"userId",
                                                                                              Login_userName,@"userName",
                                                                                              [NSNumber numberWithInt:Login_userHeadIndex],@"userHeadIndex",
                                                                                              Login_myChats, @"chats",
                                                                                              nil]];
            });
        }
    }@catch(NSException* e){
        NSLog(@"%@",e);
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_musernameTF resignFirstResponder];
    [_mpasswdTF resignFirstResponder];
}
-(void)setmport:(NSUInteger) num{
    mport = num;
}
-(void)sethost:(NSString*)host{
    mhost = host;
}
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"]intValue]) {
        case 0:{
            [Toast ShowToast:@"请输入用户名密码" Animated:YES time:1 context:self.view];
            break;
        }
        case 1:{
            break;
        }
        case 3:{
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            [dic setObject:mhost forKey:@"ip"];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)mport] forKey:@"port"];
            [self performSegueWithIdentifier:@"pushSettingView" sender:dic];
            break;
        }
        default:
            break;
    }
}
@end
