//
//  AlertAccreditActivity.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/4.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "AlertAccreditActivity.h"
#import "LoginViewController.h"
#import "AccreditMsg.pbobjc.h"
@interface AlertAccreditActivity (){
    NSString* mobileInfo;
    NSString* mobileMac;
    NSString* deviceType;
    NSString* info;
}

@end

@implementation AlertAccreditActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    mobileInfo = _intentBundle[@"mobileInfo"];
    mobileMac = _intentBundle[@"mobileMac"];
    deviceType = _intentBundle[@"deviceType"];
    info =@"";
    if([deviceType isEqualToString:@"mobile"]) {
        info = [NSString stringWithFormat:@"手机(%@)请求授权登录",mobileInfo];
        _accreditDialogOnly.hidden = NO;
    }
    else if([deviceType isEqualToString:@"pc"]) {
        info = [NSString stringWithFormat:@"电脑(%@)请求授权登录",mobileInfo];
        _accreditDialogOnly.hidden = YES;
    }
    [_accreditRequestDialogInfo setText:info];
    
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

- (IBAction)Press_accreditDialogOnly:(id)sender {
    [NSThread detachNewThreadWithBlock:^{
        @try{
            AccreditReq* accreditBuilder = [[AccreditReq alloc] init];
            accreditBuilder.accreditCode = @"11";
            accreditBuilder.accreditMac = mobileMac;
            accreditBuilder.userId = Login_userId;
            if([deviceType isEqualToString:@"mobile"])
                accreditBuilder.deviceType =  AccreditReq_DeviceType_Mobile;
            else if([deviceType isEqualToString:@"pc"])
                accreditBuilder.deviceType =  AccreditReq_DeviceType_Pc;
            accreditBuilder.type = AccreditReq_Type_Onlyonetime;
            NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_AccreditReq packetBytes:[accreditBuilder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
        }@catch (NSException* e){
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (IBAction)Press_accreditDialogAlways:(id)sender {
    [NSThread detachNewThreadWithBlock:^{
        @try{
            AccreditReq* accreditBuilder = [[AccreditReq alloc] init];
            accreditBuilder.accreditCode = @"11";
            accreditBuilder.accreditMac = mobileMac;
            accreditBuilder.userId = Login_userId;
            if([deviceType isEqualToString:@"mobile"])
                accreditBuilder.deviceType =  AccreditReq_DeviceType_Mobile;
            else if([deviceType isEqualToString:@"pc"])
                accreditBuilder.deviceType =  AccreditReq_DeviceType_Pc;
            accreditBuilder.type = AccreditReq_Type_Agree;
            NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_AccreditReq packetBytes:[accreditBuilder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
        }@catch (NSException* e){
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (IBAction)Press_accreditDialogRefuse:(id)sender {
    [NSThread detachNewThreadWithBlock:^{
        @try{
            AccreditReq* accreditBuilder = [[AccreditReq alloc] init];
            accreditBuilder.accreditCode = @"11";
            accreditBuilder.accreditMac = mobileMac;
            accreditBuilder.userId = Login_userId;
            if([deviceType isEqualToString:@"mobile"])
                accreditBuilder.deviceType =  AccreditReq_DeviceType_Mobile;
            else if([deviceType isEqualToString:@"pc"])
                accreditBuilder.deviceType =  AccreditReq_DeviceType_Pc;
            accreditBuilder.type = AccreditReq_Type_Disagree;
            NSData* reByteArray = [NetworkPacket packMessage:ENetworkMessage_AccreditReq packetBytes:[accreditBuilder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:reByteArray];
        }@catch (NSException* e){
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
@end
