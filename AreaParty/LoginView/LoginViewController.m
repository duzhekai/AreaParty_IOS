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
    
}

@end
//static变量
static Base* _base;
static NSMutableArray<UserItem*> *userFriend;
static NSMutableArray<UserItem*> *userNet;
static NSMutableArray<UserItem*> *userShare;
static NSMutableArray<FileItem*> *files;
static NSString* userId;
static NSString* userName;
static NSString* userMac;
static BOOL mainMobile;
static int userHeadIndex;
static myChatList* myChats;


@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    timer =0;
    outline =NO;
    userFriend = [[NSMutableArray alloc] init];
    userNet = [[NSMutableArray alloc] init];
    userShare = [[NSMutableArray alloc] init];
    files = [[NSMutableArray alloc] init];
    myChats = [[myChatList alloc] init];
    NSLog(@"%@",userFriend);
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //设置navigationbar的文字和颜色
    self.navigationItem.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    //设置 设置 按钮
    UIView* rightview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    UIImageView* rightimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting.png"]];
    rightimageview.frame = CGRectMake(0, 0, 23, 23);
    rightview.userInteractionEnabled=YES;
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressbtnsetting)];
    //将手势添加到需要相应的view中去
    [rightview addGestureRecognizer:tapGesture];

    [rightview addSubview:rightimageview];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem= rightItem;
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* dftusername = [defaults stringForKey:@"USER_ID"];
    NSString* dftpwd =[defaults stringForKey:@"USER_PWD"];
    mport = [defaults integerForKey:@"SERVER_PORT"];
    mhost = [defaults stringForKey:@"SERVER_IP"];
    if( mport == nil){
        mport = 3333;
        [defaults setInteger:3333 forKey:@"SERVER_PORT"];
    }
    if(mhost == nil){
        mhost = [NSString stringWithUTF8String:"119.23.12.116"];
        [defaults setObject:@"119.23.12.116" forKey:@"SERVER_IP"];
    }
    [_musernameTF setText:dftusername];
    [_mpasswdTF setText:dftpwd];
    NSLog(@"%@",mhost);
    
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
-(void) pressbtnsetting{
    
    [self performSegueWithIdentifier:@"pushSettingView" sender:nil];
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
}


- (IBAction)Press_login_btn:(UIButton *)sender {
    NSDate *now = [NSDate date];
    if(outline == NO){
        if([now timeIntervalSince1970] - timer >3){
            [NSThread detachNewThreadSelector:@selector(login) toTarget:self withObject:nil];
            timer = [now timeIntervalSince1970];
        }
        else
        [Toast ShowToast:@"正在登录" Animated:YES time:2 context:self.view];
    }
}

- (IBAction)Press_offline_btn:(id)sender {
    userId =@"";
  [self.navigationController performSegueWithIdentifier:@"pushMainView" sender:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"outline",nil]];
}

- (IBAction)Press_register_btn:(id)sender {
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
    userMac = [defaults stringForKey:@"USER_MAC"];
    userId = _musernameTF.text;
    NSString* userPwd = _mpasswdTF.text;
    [defaults setObject:userId forKey:@"USER_ID"];
    [defaults setObject:userPwd forKey:@"USER_PWD"];
    if(userMac == nil){
        userMac =[self getMacAddress];
        [defaults setObject:userMac forKey:@"USER_MAC"];
    }
    if(userId.length ==0 || userPwd.length == 0)
        [Toast ShowToast:@"请输入用户名密码" Animated:YES time:2 context:self.view];
    
    _base = [[Base alloc] initWithHost:mhost andPort: (int)mport];
    LoginReq* loginreq = [[LoginReq alloc] init];
    [loginreq setUserId:userId];
    [loginreq setUserPassword:userPwd];
    [loginreq setLoginType:LoginReq_LoginType_Mobile];
    [loginreq setUserMac:userMac];
    [loginreq setMobileInfo:[self getPhoneInfo]];
    
    NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_LoginReq packetBytes:[loginreq data]];
    [_base writeToServer:_base.outputStream arrayBytes:byteArray];
    byteArray = [_base readFromServer:_base.inputStream];
    if([byteArray length]==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"用户名或密码错误" Animated:YES time:2 context:self.view];
            userId =@"";
            [_base close];
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
                userId=@"";
                [_base close];
            });
            return;
        }
        else if(response.resultCode == LoginRsp_ResultCode_Loggedin){
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast ShowToast:@"您的账号已登录" Animated:YES time:2 context:self.view];
                userId=@"";
                [_base close];
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
                byteArray = [_base readFromServer:_base.inputStream];
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
                        [_base writeToServer:_base.outputStream arrayBytes:reByteArray];
                    }
                    else if(accreditRespanse.resultCode == AccreditRsp_ResultCode_Canlogin){
                        byteArray = [NetworkPacket packMessage:ENetworkMessage_LoginReq packetBytes:[loginreq data]];
                        [_base writeToServer:_base.outputStream arrayBytes:byteArray];
                    }
                    else if(accreditRespanse.resultCode == AccreditRsp_ResultCode_Fail){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.alertController setTitle:@"授权失败"];
                            [self.alertController setMessage:@"主设备拒绝授权您的手机使用该账号进行登录"];
                            [self presentViewController: self.alertController animated:YES completion:nil];
                            [_base close];
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
                [self.alertController setTitle:@"主设备不在线"];
                [self.alertController setMessage:@"请打开主设备进行授权操作"];
                [self presentViewController: self.alertController animated:YES completion:nil];
                [_base close];
            });
            return;
        }
        if(response.mainMobileCode == LoginRsp_MainMobileCode_Yes){
            mainMobile = YES;
        }
        else if(response.mainMobileCode == LoginRsp_MainMobileCode_No){
            mainMobile = NO;
        }
        [_base.onlineUserId removeAllObjects];
        [userFriend removeAllObjects];
        [userNet removeAllObjects];
        [userShare removeAllObjects];
        [_base.onlineUserId addObject:userId];
        //用户分类
        NSMutableArray* lu = [response userItemArray];
        if([lu count]!=0){
            for(UserItem* u in lu){
                if([u.userId isEqualToString:userId]) continue;
                if(u.isOnline){
                    [_base.onlineUserId addObject:u.userId];
                }
                if(u.isFriend){
                    [userFriend addObject:u];
                }
                else if(u.fileNum >= _base.getFileNum){
                    [userShare addObject:u];
                }
                else{
                    NSLog(@"%@",u.userId);
                }
            }
        }
        NSMutableArray* chats = response.chatItemArray;
        [myChats setList:chats];
        GetUserInfoReq* userBuilder = [[GetUserInfoReq alloc] init];
        [userBuilder.targetUserIdArray addObject:userId];
        [userBuilder setFileInfo:YES];
        NSData* filebyteArray = [NetworkPacket packMessage:ENetworkMessage_GetUserinfoReq packetBytes:[userBuilder data]];
        [_base writeToServer:_base.outputStream arrayBytes:filebyteArray];
        byteArray = [_base readFromServer:_base.inputStream];
        byteArray_b = [byteArray bytes];
        size = [DataTypeTranslater bytesToInt:(Byte *)byteArray_b offset:0];
        
        type = [DataTypeTranslater bytesToInt:(Byte *)byteArray_b offset:4];
        
        if(type == ENetworkMessage_GetUserinfoRsp){
            int objlength = size - [NetworkPacket getMessageObjectStartIndex];
            Byte objBytes[objlength];
            for(int i =0; i < objlength;i++)
                objBytes[i] = byteArray_b[[NetworkPacket getMessageObjectStartIndex]+i];
            GetUserInfoRsp* fileresponse = [GetUserInfoRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
            userName = fileresponse.userItemArray[0].userName;
            userHeadIndex = fileresponse.userItemArray[0].headIndex;
            
            if(fileresponse.resultCode == GetUserInfoRsp_ResultCode_Success){
                if([fileresponse.userItemArray[0].userId isEqualToString:userId]){
                    files = fileresponse.filesArray;
                    NSDateFormatter* formartter = [[NSDateFormatter alloc] init];
                    [formartter setDateFormat:@"yyyy/MM/dd HH:mm"];
                    for(FileItem* file in files){
                        SharedflieBean* sharedFile = [[SharedflieBean alloc] init];
                        sharedFile.id = [file.fileId intValue];
                        sharedFile.name =file.fileName;
                        sharedFile.des = file.fileInfo;
                        sharedFile.size = [file.fileSize intValue];
                        long time = [file.fileDate longLongValue];
                        sharedFile.timeLong = time;
                        sharedFile.timeStr = [formartter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:(time/1000)]];
                        [MyUIApplication addMySharedFlies:[[SharedflieBean alloc] init]];
                    }
                }
            }else{
                //保留
            }
        }
        [[[NSThread alloc] initWithTarget:_base selector:@selector(listen) object:nil] start];
        //跳转主界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController performSegueWithIdentifier:@"pushMainView" sender:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"outline",
                                              userId,@"userId",
                                              userName,@"userName",
                                              [NSNumber numberWithInt:userHeadIndex],@"userHeadIndex",
                                              nil]];
        });
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_musernameTF resignFirstResponder];
    [_mpasswdTF resignFirstResponder];
}
+ (NSMutableArray *)userFriend{
    return userFriend;
}
+ (NSMutableArray *)userNet{
    return userNet;
}
+ (NSMutableArray *)userShare{
    return userShare;
}
+ (NSMutableArray *)files{
    return files;
}
+ (myChatList *)myChats{
    return myChats;
}
-(void)setmport:(NSUInteger) num{
    mport = num;
}
-(void)sethost:(NSString*)host{
    mhost = host;
}
+ (NSString*) getuserId{
    return userId;
}
+ (NSString*) getuserMac{
    return userMac;
}
+ (NSString*) getuserName{
    return userName;
}
+(Base*) getBase{
    return _base;
}
@end
