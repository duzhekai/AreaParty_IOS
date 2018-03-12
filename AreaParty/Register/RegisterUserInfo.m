//
//  RegisterUserInfo.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/5.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "RegisterUserInfo.h"

@interface RegisterUserInfo (){
    NSString* userId;
    NSString* userName;
    NSString* userKeyword;
}

@end

@implementation RegisterUserInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下一步按钮
    _Next_Btn.backgroundColor = [UIColor colorWithRed:60/255.0f green:175/255.0f blue:250/255.0f alpha:1.0];
    _Next_Btn.layer.cornerRadius = 5;
    //初始化
    _checked = YES;
    [_Checkbox_btn setSelected:YES];
    
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
    RegisterPersonalInfo* targetvc = (RegisterPersonalInfo*)[segue destinationViewController];
    NSDictionary* dic = (NSDictionary*)sender;
    [targetvc setuserid:[dic objectForKey:@"userid"]];
    [targetvc setusername:[dic objectForKey:@"username"]];
    [targetvc setkeyword:[dic objectForKey:@"userkw"]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_et_userName resignFirstResponder];
    [_et_userId resignFirstResponder];
    [_et_keyword resignFirstResponder];
    [_et_keywordAgain resignFirstResponder];
}

- (IBAction)Press_checkbox:(id)sender {
    if(_checked == YES){
        [_Checkbox_btn setSelected:NO];
        _checked =NO;
    }
    else{
        [_Checkbox_btn setSelected:YES];
        _checked = YES;
    }
}

- (IBAction)Press_Next_btn:(id)sender {
    if(!_checked){
        [Toast ShowToast: @"请先阅读服务条款" Animated:YES time:2 context:self.view];
        return;
    }
    NSString* keyword = _et_keyword.text;
    NSString* keywordAgain = _et_keywordAgain.text;
    userId = _et_userId.text;
    userName = _et_userName.text;
    if(![userId isEqualToString:@""]){
        BOOL checkUserId = [self isUserIdNO:userId];
        if(!checkUserId){
            [Toast ShowToast:@"请正确输入6-20位用户名" Animated:YES time:2 context:self.view];
            return;
        }
        if(![userName isEqualToString:@""]){
            BOOL checkUsername = [self isUserNameNO:userName];
            if(!checkUsername){
                [Toast ShowToast:@"请正确输入昵称" Animated:YES time:2 context:self.view];
                return;
            }
            if([keyword isEqualToString:@""]||(![self isKeyWord:keyword])){
                [Toast ShowToast:@"请正确输入6-20位密码" Animated:YES time:2 context:self.view];
                return;
            }
            if([keywordAgain isEqualToString:@""]||(![self isKeyWord:keywordAgain])){
                [Toast ShowToast:@"请重新正确输入6-20位密码" Animated:YES time:2 context:self.view];
                return;
            }
            if([keyword isEqualToString:keywordAgain]){
                userKeyword = keyword;
                //开启注册线程
                NSThread* thread =  [[NSThread alloc] initWithTarget:self selector:@selector(register) object:nil];
                [thread start];
                
            }
            else{
                [Toast ShowToast:@"两次输入的密码不一致，请重新输入" Animated:YES time:2 context:self.view];
            }
        }
        else{
            [Toast ShowToast:@"请输入昵称" Animated:YES time:2 context:self.view];
        }
    }
    else{
        [Toast ShowToast:@"请输入用户名" Animated:YES time:2 context:self.view];
    }
    
}

- (BOOL) isUserIdNO:(NSString*) userid{
    NSRange range = [userid rangeOfString:@"^[a-zA-Z][a-zA-Z0-9]{5,19}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}
- (BOOL) isUserNameNO:(NSString*) username{
    NSRange range = [username rangeOfString:@"^[\\u4e00-\\u9fa5_a-zA-Z0-9-]{1,16}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}
- (BOOL) isKeyWord:(NSString*) kw{
    NSRange range = [kw rangeOfString:@"^([A-Z]|[a-z]|[0-9]|[`~!@#$%^&*()+=|{}':;',\\\\\\\\[\\\\\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]){6,20}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}
-(void) register{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger port = [defaults integerForKey:@"SERVER_PORT"];
    NSString* host = [defaults objectForKey:@"SERVER_IP"];
    RegisterReq* req = [[RegisterReq alloc] init];
    [req setRequestCode:RegisterReq_RequestCode_Checkuserid];
    [req setUserId:userId];
    [req setUserPassword:userKeyword];
    [req setUserName:userName];
    
    Base* base = [[Base alloc] initWithHost:host andPort:(int)port];
    NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_RegisterReq packetBytes:[req data]];
    [base writeToServer:base.outputStream arrayBytes:byteArray];
    byteArray = [base readFromServer:base.inputStream];
    const Byte* byteArray_b = [byteArray bytes];
    if(byteArray.length ==0){
        //网络不行
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast ShowToast:@"连接断开，请检查网络后重试" Animated:YES time:2 context:self.view];
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
        RegisterRsp* res = [RegisterRsp parseFromData:[NSData dataWithBytes:objBytes length:objlength] error:nil];
        NSLog(@"%d%d",res.resultType,res.resultCode);
        if(res.resultType == RegisterRsp_ResultType_Userid){
            if(res.resultCode == RegisterRsp_ResultCode_Success){
                //跳转personalinfo
                dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary* dic = @{@"userid":userId,@"username":userName,@"userkw":userKeyword};
                [self performSegueWithIdentifier:@"pushPersonalInfo" sender:dic];
                });
                [base close];
            }
            else if(res.resultCode == RegisterRsp_ResultCode_Exist){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_et_userId setText:@""];
                    [Toast ShowToast:@"该用户名已被注册，请重新输入" Animated:YES time:2 context:self.view];
                });
                [base close];
            }
        }
    }
}
@end
