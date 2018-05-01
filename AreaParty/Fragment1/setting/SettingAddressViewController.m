//
//  SettingAddressViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SettingAddressViewController.h"
#import "Toast.h"
#import "PersonalSettingsMsg.pbobjc.h"
#import "NetworkPacket.h"
#import "SettingAddressHandler.h"
@interface SettingAddressViewController ()

@end
static SettingAddressHandler* mhandler;
@implementation SettingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mhandler = [[SettingAddressHandler alloc] initWithController:self];
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
    if([[segue identifier] isEqualToString:@"pushCityPickerViewInSettting"]){
        CityPickerViewController* target = (CityPickerViewController*)[segue destinationViewController];
        target.fathervc = sender;
    }
}

- (IBAction)press_select_address:(id)sender {
    [self performSegueWithIdentifier:@"pushCityPickerViewInSettting" sender:self];
}
- (IBAction)press_ok:(id)sender {
    if([_setting_address.titleLabel.text isEqualToString:@"请选择地址"]){
        [Toast ShowToast:@"请选择地区" Animated:YES time:2 context:self.view];
        return;
    }
    if([_setting_street.text isEqualToString:@""]){
        [Toast ShowToast:@"请正确填写居住街道" Animated:YES time:2 context:self.view];
        return;
    }
    if([_setting_community.text isEqualToString:@""]){
        [Toast ShowToast:@"请正确填写居住小区" Animated:YES time:2 context:self.view];
        return;
    }
    
    [NSThread detachNewThreadWithBlock:^(void){
        PersonalSettingsReq* builder = [[PersonalSettingsReq alloc] init];
        [builder setUserAddress:_setting_address.titleLabel.text];
        [builder setUserStreet:_setting_street.text];
        [builder setUserCommunity:_setting_community.text];
        NSData* reByteArray;
            @try {
                reByteArray = [NetworkPacket packMessage:ENetworkMessage_PersonalsettingsReq packetBytes:[builder data]];
                [Login_base writeToServer: Login_base.outputStream arrayBytes:reByteArray];
            } @catch (NSException* e) {
            }
    }];
}
- (void)onUIControllerResultWithCode:(int)resultCode andData:(NSDictionary *)data{
    [self.setting_address setTitle:[data objectForKey:@"address"] forState:UIControlStateNormal];
    [self.setting_address setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
+ (SettingAddressHandler*) getHandler {
    return mhandler;
}
@end
